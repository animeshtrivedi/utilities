#!/bin/bash 

# This utility shows number of live and total objects and space for a JVM
# Author: Animesh Trivedi
#         atr@zurich.ibm.com

if [ $# -ne 1 ]; then 
	echo "Pass the PID please" 
	exit 1
fi

loop=0 
name=$(jps -l 2>&1 | grep $1 | awk '{print $2}')  
printf "# profile for : $name \n"
printf "# date  \t #all_objs \t\t all_size(KB) \t\t #live_objs \t\t live_size(KB)\n"
while [[ $name ]]; do 
       # we can check here if the process is still alive 
	live=$(jmap -histo:live $1 2>&1 | tail -1 | awk '{print $2,"\t\t",$3/1024}') 
	all=$(jmap -histo $1 2>&1 | tail -1 | awk '{print $2,"\t\t",$3/1024}') 
	d=$(date +%T)
	printf "%s \t %s \t\t %s\n" "$d" "$all" "$live"
	loop=$(($loop + 1)) 
	if [ $loop -eq 10 ]; then 
	       loop=0 
	       printf "# profile for : $name \n"
	       printf "# date  \t #all_objs \t\t all_size(KB) \t\t #live_objs \t\t live_size(KB)\n"
       fi
       sleep 1 
       name=$(jps -l 2>&1 | grep $1 | awk '{print $2}')  
       if [[ ! $name ]]; then 
	       echo "ERROR: PID $1 is not alive anymore, exiting..."
       fi
done
