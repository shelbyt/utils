#!/bin/bash
# By yskoh@mellanox.com
if [ ! -d /dev/mst ]; then
    sudo mst start
fi
PCI_FUNCS=$(sudo mst status -v | awk '/ConnectX/ { print $3 }')
# Set MaxReadReq to 1024
for i in $PCI_FUNCS; do
    OLD=$(sudo setpci -s $i 68.w)
    NEW="3${OLD:1}"
    sudo setpci -s $i 68.w=$NEW #Was getting 100G without this being run I think
    echo "[${i}] 68.w=$OLD -> $(sudo setpci -s $i 68.w)"
done

# Disable flow control
NETIFS=$(ibdev2netdev | awk '/mlx/{print $5}')
for i in $NETIFS; do
    NETIF=${i#net-}
    sudo ethtool -A $NETIF rx off tx off >& /dev/null
    sudo ethtool -a $NETIF
done
