#!/bin/bash

usage() {
    echo "
    usage: $0 options

    This script configures fixed ip on eth1

    OPTIONS:
       -i      IP to set
       -n      Netmask to set
       -g      Gateway to set
    
       -?	   This help
    ";

    exit;
}

while getopts “i:n:g:?” OPTION
do
     case $OPTION in
        i)
            NETWORK_IP=$OPTARG;
            ;;
        n)
            NETWORK_NETMASK=$OPTARG;
            ;;
        g)
            NETWORK_GATEWAY=$OPTARG;
            ;;

        ?)
            usage;
            ;;
     esac
done

echo "auto lo" > /etc/network/interfaces;
echo "iface lo inet loopback" >> /etc/network/interfaces;

echo "auto eth0" >> /etc/network/interfaces;
echo "iface eth0 inet dhcp" >> /etc/network/interfaces;

if [ -n "$NETWORK_IP" ]; then
    echo "auto eth1" >> /etc/network/interfaces;
    echo "iface eth1 inet static" >> /etc/network/interfaces;
    echo "  address $NETWORK_IP" >> /etc/network/interfaces;
    echo "  netmask $NETWORK_NETMASK" >> /etc/network/interfaces;
    echo "  gateway $NETWORK_GATEWAY" >> /etc/network/interfaces;
    echo "" >> /etc/network/interfaces;
else
    echo "auto eth1" >> /etc/network/interfaces;
    echo "iface eth1 inet dhcp" >> /etc/network/interfaces;
fi
