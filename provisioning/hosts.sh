#!/bin/bash

usage() {
    echo "
    usage: $0 options

    This script sets some hosts entry on a virtual guest system

    OPTIONS:
       -h      Hostname to set
       -d      Domain to set
       -p      Puppetmaster hostname to set
       -i      Puppet master ip to set
       -?	   This help
    ";

    exit;
}

while getopts “h:d:p:i:?” OPTION
do
     case $OPTION in
        h)
            NAME=$OPTARG;
            ;;
        d)
            DOMAIN=$OPTARG;
            ;;
        p)
            PUPPET_MASTER_HOSTNAME=$OPTARG;
            ;;
        i)
            PUPPET_MASTER_IP=$OPTARG;
            ;;


        ?)
            usage;
            ;;
     esac
done

FQDN=$NAME.$DOMAIN;
PUPPET_MASTER_FQDN=$PUPPET_MASTER_HOSTNAME.$DOMAIN
echo "127.0.0.1       localhost" > /etc/hosts;
echo "127.0.0.1       $FQDN $NAME" >> /etc/hosts;
echo "" >> /etc/hosts;
echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts;
echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts;
echo "ff02::1 ip6-allnodes" >> /etc/hosts;
echo "ff02::2 ip6-allrouters" >> /etc/hosts;

echo "" >> /etc/hosts;


echo "$PUPPET_MASTER_IP       $PUPPET_MASTER_HOSTNAME $PUPPET_MASTER_FQDN" >> /etc/hosts;
