#!/bin/bash 
# Animesh Trivedi 

if [ $# -ne 1 ]; then 
	echo "which device? Just say nvme0n1, without the dev "
	exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "ERROR: this script must be run as root" 
   exit 1
fi

set -x 
device=$1
mount | grep $device
if [ $? -eq 0 ]; then 
	echo "Device $1 is already mounted"
	exit 1
fi 

# Otherwise we proceed to mount 
loc=/mnt/$device 
mkdir -p $loc
mount /dev/$device $loc
if [ $? -eq 32 ]; then
	set -e 
	#echo "$device is not formatted, making ext4 system on it"
	#mkfs.ext4 /dev/$device	
	echo "$device is not formatted, making xfs system on it"
	mkfs.xfs /dev/$device
	mount /dev/$device $loc
fi
set -e 
chown -R $SUDO_USER $loc 
echo "OK: $device is mounted at $loc for user $SUDO_USER"
