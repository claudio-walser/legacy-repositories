#!/bin/bash
PUPPET_MASTER_NAME='puppet-master-01';
PUPPET_MASTER_IP='10.20.1.2';

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
apt-get --yes install rsync;

echo 'Set hostname';
. /mnt/hgfs/provisioning/hostname.sh;
echo 'Set hosts file';
. /mnt/hgfs/provisioning/hosts.sh;
echo 'Rsync shared folders';
. /mnt/hgfs/provisioning/shared-folders.sh;

echo 'Reload hostname';
# reload hostname
service hostname.sh stop;
service hostname.sh start;



# this guy makes problems, take it to the very end
echo 'Setup and configure puppet agent and master if needed';
. /mnt/hgfs/provisioning/puppet.sh

exit 1;
