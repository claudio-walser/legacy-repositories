#!/bin/bash

FQDN=$(/usr/sbin/vmtoolsd --cmd 'machine.id.get');

HOSTNAME='';
DOMAIN='';

OLD_IFS=$IFS;
IFS='.';
for i in $FQDN; do
	if [[ $HOSTNAME == '' ]]; then
		HOSTNAME=$i;
    elif [[ $DOMAIN == '' ]]; then
    	DOMAIN=$i;
    elif [[ $DOMAIN != '' ]]; then
    	DOMAIN="$DOMAIN.$i";
    fi
done
IFS=$OLD_IFS; 


#echo $HOSTNAME;
#echo $DOMAIN;

echo 'Basic provision starts';

. hostname.sh;
. hosts.sh;

if [[ "${HOSTNAME:0:13}" == "puppet-master" ]]; then
    . puppet-master.sh;
fi

echo 'Basic provision done';
