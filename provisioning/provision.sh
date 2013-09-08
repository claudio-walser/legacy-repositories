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
apt-get --yes install puppet rsync;

. /mnt/hgfs/provisioning/hostname.sh;
. /mnt/hgfs/provisioning/hosts.sh;
. /mnt/hgfs/provisioning/shared-folders.sh;

if [[ "${HOSTNAME:0:13}" == "puppet-master" ]]; then
    . /mnt/hgfs/provisioning/puppet-master.sh;

    echo "127.0.0.1       puppet" >> /etc/hosts;
else
	echo "10.20.1.2       puppet" >> /etc/hosts;
fi



puppet agent --test;

echo 'Basic provision done';
