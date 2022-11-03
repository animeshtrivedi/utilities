#!/bin/bash
NVME_DEVICE="/dev/nvme0n1"
SERVER_IP_ADDR="190.160.10.8"
SERVER_IP_PORT=4420
NAMESPACE_NAME="nvme-atr-target"

set -e
sudo modprobe nvmet
sudo modprobe nvmet-tcp
echo "1. modprobe done..."

cd /sys/kernel/config/nvmet/subsystems
sudo mkdir $NAMESPACE_NAME
cd $NAMESPACE_NAME/
echo 1 | sudo tee -a attr_allow_any_host > /dev/null
sudo mkdir namespaces/1
cd namespaces/1
echo -n $NVME_DEVICE |sudo tee -a device_path > /dev/null
echo 1|sudo tee -a enable > /dev/null
echo "2. a target namespace done..."

sudo mkdir /sys/kernel/config/nvmet/ports/1
cd /sys/kernel/config/nvmet/ports/1
echo $SERVER_IP_ADDR | sudo tee -a addr_traddr > /dev/null
echo tcp | sudo tee -a addr_trtype > /dev/null
echo $SERVER_IP_PORT |sudo tee -a addr_trsvcid > /dev/null
echo ipv4 | sudo tee -a addr_adrfam > /dev/null
echo "3. port setup done..."

sudo ln -s /sys/kernel/config/nvmet/subsystems/$NAMESPACE_NAME/ /sys/kernel/config/nvmet/ports/1/subsystems/$NAMESPACE_NAME
echo "4. linking done...see the dmesg log output (last 10 lines)"
dmesg | tail -10