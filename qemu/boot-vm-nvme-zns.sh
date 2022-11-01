#!/bin/bash
#ubuntu-2004.qcow2 or ubuntu-20.04-stosys-v5.12.qcow
QEMU_HOME="/home/atr/src/qemu-6.1.0/build/"
QEMU_BUILD=$QEMU_HOME/build/
OS_IMG_PATH="/mnt/sdb/atr/ubuntu-20.04-stosys-v5.12.qcow"
NVME1_PATH="/mnt/sdb/atr/nvmessd-4G.img"
#ZNS_PATH="/mnt/sdb/4tb/atr/"
#-drive file=znsssd-32M.img,id=zns-device,format=raw,if=none \

set -ex
sudo $QEMU_BUILD/qemu-system-x86_64 \
-name qemunvme-$((1 + $RANDOM % 10)) -m 32G --enable-kvm -cpu host -smp 4 \
-hda $OS_IMG_PATH \
-net user,hostfwd=tcp::7777-:22 -net nic \
-drive file=$NVME1_PATH,id=nvme-device,format=raw,if=none \
-device nvme,drive=nvme-device,serial=nvme-dev,physical_block_size=512,logical_block_size=512 \
-netdev bridge,id=hn0,br=br1,helper=$QEMU_BUILD/qemu-bridge-helper -device virtio-net-pci,netdev=hn0,id=nic1 #\mac=e6:c8:ff:09:76:99,