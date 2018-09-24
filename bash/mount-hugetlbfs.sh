#!/bin/bash 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
loc=/mnt/hugetlbfs
mount | grep $loc 
if [ $? -eq 0 ]; then 
	echo "$loc already mounted" 
	exit 1
fi 


mkdir -p $loc
mount -t hugetlbfs none $loc
mkdir -p $loc/craildata/datanode/
mkdir -p $loc/craildata/cache/
chown -R $SUDO_USER $loc
echo "mounted at : $loc for user $SUDO_USER" 
