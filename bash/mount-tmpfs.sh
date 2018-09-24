#!/bin/bash
loc=/mnt/tmpfs
mkdir -p $loc
h=`hostname`
num=${h:4:2}

if [[ $EUID -ne 0 ]]; then
   echo "ERROR: This script must be run as root" 
   exit 1
fi

if [ $num -lt 12 ]; then 
	SIZE=32G
	echo "INFO: $h is 1U machine, doing a $SIZE mount" 
else
	SIZE=160G
	echo "INFO: $h is 2U machine, doing a $SIZE mount" 
fi

if [ $# -eq 1 ]; then 
	echo "Picking up the passed size as : $1"
	SIZE=$1
fi

mount | grep $loc 
if [ $? -eq 0 ]; then 
	echo "ERROR: Location $loc is already mounted" 
	exit 1;
fi 
set -e 
mount -t tmpfs -o size=$SIZE tmpfs $loc 
mkdir -p $loc/tmp/
chown -R $SUDO_USER $loc 
echo "OK: Tmpfs mounted at $loc with user $SUDO_USER and size $SIZE"  
