#!/bin/bash
if [ $# -ne 1 ]; then
    echo "which nic?"
    exit 1;
fi
P="/sys/class/net/$1/statistics/"

while true; do
    TX0=$(cat $P/tx_bytes)
    RX0=$(cat $P/rx_bytes)
    TX0_P=$(cat $P/tx_packets)
    RX0_P=$(cat $P/rx_packets)

    sleep 1

    TX1=$(cat $P/tx_bytes)
    RX1=$(cat $P/rx_bytes)
    TX1_P=$(cat $P/tx_packets)
    RX1_P=$(cat $P/rx_packets)

    RX_PKTS=$(($RX1_P - $RX0_P))
    RX_BYTES=$(( $RX1 - $RX0))
    TX_PKTS=$(($TX1_P - $TX0_P))
    TX_BYTES=$(( $TX1 - $TX0))

    #printf "tx: %d - rx: %d Mbps || tx: %d - rx: %d \n" $((($TX1-$TX0)/1024/1024*4)) $((($RX1-$RX0)/1024/1024*4)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P))
    #printf "tx: %d - rx: %d Mbps || tx: %d - rx: %d \n" $((($TX1-$TX0)/1000/1000*32)) $((($RX1-$RX0)/1000/1000*32)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P))
    #printf "tx: %d - rx: %d Bytes || %d %d \n" $((($TX1-$TX0) * 4)) $((($RX1-$RX0) * 4)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P))
    #printf "tx (B): %d - rx: %d || tx: %d rx: %d packets || %d \n" $TX_BYTES $RX_BYTES $TX_PKTS $RX_PKTS $(($RX_BYTES/$RX_PKTS))
    printf "tx (B): %d - rx: %d || tx: %d rx: %d packets \n" $TX_BYTES $RX_BYTES $TX_PKTS $RX_PKTS
done

