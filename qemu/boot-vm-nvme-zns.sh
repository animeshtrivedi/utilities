#!/bin/bash
#ubuntu-2004.qcow2 or ubuntu-20.04-stosys-v5.12.qcow
QEMU_PATH="/home/atr/src/qemu-6.1.0/build/"
OS_IMG_PATH="/mnt/sdb/4tb/atr/ubuntu-20.04-stosys-v5.12.qcow"
NVME1_PATH="/mnt/sdb/4tb/atr/nvmessd-4G.img"
#ZNS_PATH="/mnt/sdb/4tb/atr/"
#-drive file=znsssd-32M.img,id=zns-device,format=raw,if=none \

set -ex
sudo $QEMU_PATH/qemu-system-x86_64 \
-name qemuzns -m 32G --enable-kvm -cpu host -smp 4 -accel kvm \
-hda $OS_IMG_PATH \
-net user,hostfwd=tcp::7777-:22 -net nic \
-drive file=$NVME1_PATH,id=nvme-device,format=raw,if=none \
-device nvme,drive=nvme-device,serial=nvme-dev,physical_block_size=4096,logical_block_size=4096