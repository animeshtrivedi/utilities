#!/bin/bash
set -ex
BRIDGE_NAME=br10
sudo ip link add $BRIDGE_NAME type bridge
sudo ip addr add 190.160.10.1/24 dev $BRIDGE_NAME
sudo ip link set $BRIDGE_NAME up

set +x
echo "If you want details for the QEMU, then add the following line"
echo "In an outside installation of QEMU, you will have config file in the source folder: QEMU_SRC/etc/qemu/bridge.conf"
echo "echo 'allow br0' | sudo tee -a /etc/qemu/bridge.conf"