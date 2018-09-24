#!/bin/bash 
# Author: Animesh Trivedi
#         atr@zurich.ibm.com
#         July, 2013 

show_hpage_status()
{ 
total=$(cat /proc/meminfo | grep HugePages_Total | awk '{print $2}')
free=$(cat /proc/meminfo | grep HugePages_Free | awk '{print $2}')
echo "INFO: Total pages: $total, free pages $free" 
}

if [ $# -ne 1 ]; then 
        show_hpage_status
	echo "ERROR: Pass me a number, if you want to set the number" 
	exit 1
fi 
echo "Setting up huge pages to be : $1 "
echo $1 > /proc/sys/vm/nr_hugepages
show_hpage_status
echo "**** Details **** " 
cat /proc/meminfo | grep Huge
