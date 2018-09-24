#!/bin/bash 
# Author: Animesh Trivedi
#	  atr@zurich.ibm.com

sample_freq=1.0
temp=".temp"
CCODE="int main(){while (1);return 0;}"
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

trap ctrl_c INT
function ctrl_c() {
        echo "** Trapped CTRL-C, aborting "
	kill -9 `pidof yes` &> /dev/null
	exit 1;
}
echo $CCODE > ./loop.c 
gcc loop.c -o loop.out
echo "Calibrating...."
./loop.out & 
pid=$!
#echo "PID of the CPU stresses is: $pid" 
sleep 1
perf stat -x " " -a -e cycles -r 5 -- sleep $sample_freq &>$temp;
fullload=`cat $temp | awk '{print $1}'`
echo "CPU cycles for a single 100% loaded cpu for $sample_freq sec is: $fullload"
kill -9 $pid 
pidof loop.out 
ret=$?
if [ $ret -eq 0 ]; then 
	echo "We got some PID...aborting. Please run the script again." 
	kill -9 `pidof yes` &> /dev/null
	exit 1;
fi
rm loop.c 

# done calibrating 
file="`pwd`/cpu-sample"
echo "Starting the profile now (data saved in : $file) ..."
rm $file &> /dev/null
fcounter=0
echo "----------------------------------------------------------"
show_again=10
printf "  Time \t\t CPU load \t KernelSpace \t UserSpace \n"   
counter=0
while [ true ]; 
do
	perf stat -x " " -a -e cycles:u,cycles:k -- sleep $sample_freq &>$temp;
	ucycles=`cat $temp | grep "cycles:u" | awk '{print $1}'`
	kcycles=`cat $temp | grep "cycles:k" | awk '{print $1}'`
	total=$(($ucycles + $kcycles))
	
	load=$((100 * $total / $fullload))
	uload=$(($ucycles * 100 / $total ))
	kload=$(($kcycles * 100 / $total ))
	printf "`date +"%T"`\t %d%% \t\t %d%% \t\t %d%% \n" $load $kload $uload 
#	printf " %d \t %d \t\t %d \t\t %d \n" $fcounter $load $kload $uload >> $file 
	counter=$(($counter+1))
	fcounter=$(($fcounter+1))
	if [ $counter -eq $show_again ]; then 
		counter=0;
		printf "  Time \t\t CPU load \t KernelSpace \t UserSpace \n"   
	fi
done 

