#!/bin/bash

usage() {
    echo "
    usage: $0 options

    This script sets the hostname on a virtual guest system

    OPTIONS:
       -h      Hostname to set
       -?	   This help
    ";

    exit;
}

NAME='debian-1';
while getopts “h:?” OPTION
do
     case $OPTION in
        h)
            NAME=$OPTARG;
            ;;
        ?)
            usage;
            ;;
     esac
done


echo $NAME > /etc/hostname;
