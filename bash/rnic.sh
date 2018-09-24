#!/bin/bash
# https://community.mellanox.com/docs/DOC-2572 

P="/sys/class/infiniband/mlx5_1/ports/1/counters/"
while true; do
    TX0=$(cat $P/port_xmit_data)
    RX0=$(cat $P/port_rcv_data)
    TX0_P=$(cat $P/port_xmit_packets)
    RX0_P=$(cat $P/port_rcv_packets)
    ARRAY0=($(ethtool -S enp17s0f1 | grep rdma_unicast | awk '{print $2}'))
    sleep 1
    TX1=$(cat $P/port_xmit_data)
    RX1=$(cat $P/port_rcv_data)
    TX1_P=$(cat $P/port_xmit_packets)
    RX1_P=$(cat $P/port_rcv_packets)
    ARRAY1=($(ethtool -S enp17s0f1 | grep rdma_unicast | awk '{print $2}'))
    
    RX_PKTS=$((${ARRAY1[0]} - ${ARRAY0[0]})) 
    RX_BYTES=$((${ARRAY1[1]} - ${ARRAY0[1]})) 
    TX_PKTS=$((${ARRAY1[2]} - ${ARRAY0[2]})) 
    TX_BYTES=$((${ARRAY1[3]} - ${ARRAY0[3]})) 


    #printf "tx: %d - rx: %d Mbps || tx: %d - rx: %d \n" $((($TX1-$TX0)/1024/1024*4)) $((($RX1-$RX0)/1024/1024*4)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P)) 
    #printf "tx: %d - rx: %d Mbps || tx: %d - rx: %d \n" $((($TX1-$TX0)/1000/1000*32)) $((($RX1-$RX0)/1000/1000*32)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P)) 
    #printf "tx: %d - rx: %d Bytes || %d %d \n" $((($TX1-$TX0) * 4)) $((($RX1-$RX0) * 4)) $(($TX1_P - $TX0_P)) $(($RX1_P - $RX0_P)) 
    printf "tx (B): %d - rx: %d || tx: %d rx: %d packets || %d \n" $TX_BYTES $RX_BYTES $TX_PKTS $RX_PKTS $(($RX_BYTES/$RX_PKTS))
done

