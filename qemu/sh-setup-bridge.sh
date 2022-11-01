#!/bin/bash
BRIDGE_NAME=br10
set -ex
sudo ip link add $BRIDGE_NAME type bridge
sudo ip addr add 190.160.10.1/24 dev $BRIDGE_NAME
sudo ip link set $BRIDGE_NAME up

set +x
echo "If you want details for the QEMU, then add the following line"
echo "In an outside installation of QEMU, you will have config file in the source folder: QEMU_SRC/etc/qemu/bridge.conf"
echo "echo 'allow $BRIDGE_NAME' | sudo tee -a /etc/qemu/bridge.conf"