#!/bin/bash
NVME_DEVICE="/dev/nvme0n1"
MNT_POINT="/mnt/nvmf-tcp"

set -ex
sudo mount $NVME_DEVICE  $MNT_POINT
sudo chown -R user $MNT_POINT
touch $MNT_POINT/abc
rm $MNT_POINT/abc