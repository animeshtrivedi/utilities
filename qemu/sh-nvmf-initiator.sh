#!/bin/bash
NVME_DEVICE="/dev/nvme0n1"
SERVER_IP_ADDR="190.160.10.8"
SERVER_IP_PORT=4420
NAMESPACE_NAME="nvme-atr-target"

set -e
sudo modprobe nvme
sudo modprobe nvme-tcp
echo "1. modprobe done..."

echo "2. discovering...."
sudo nvme discover -t tcp -a $SERVER_IP_ADDR -s $SERVER_IP_PORT --hostnqn=nqn.2014-08.org.nvmexpress:uuid:1b4e28ba-2fa1-11d2-883f-0016d3ccabcd

echo "3. connecting..."
sudo nvme connect -t tcp -n $NAMESPACE_NAME -a $SERVER_IP_ADDR -s $SERVER_IP_PORT --hostnqn=nqn.2014-08.org.nvmexpress:uuid:1b4e28ba-2fa1-11d2-883f-0016d3ccabcd

echo "4. show list"
sudo nvme list

echo "5. mounting the file system"

# how to disconnect
# sudo nvme disconnect /dev/nvme0n1 -n nvme-test-target
