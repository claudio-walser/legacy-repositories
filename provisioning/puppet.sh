#!/bin/bash


usage() {
    echo "
    usage: $0 options

    This script set up a puppet client

    OPTIONS:
       -p      Puppet master fqdn
    
       -?	   This help
    ";

    exit;
}

while getopts “p:i:?” OPTION
do
     case $OPTION in
        p)
            PUPPET_MASTER_FQDN=$OPTARG;
            ;;

        ?)
            usage;
            ;;
     esac
done



# update apt repos
apt-get update;

# write agent config, cause i had to install it after the master 
# i have to take care on puppet-masters, they already have the config
# install puppet agent cause it overwrites the config file on installation :(
apt-get --yes --force-yes install puppet;

# correct configs for our puppet setup
echo "[main]" > /etc/puppet/puppet.conf;
echo "server=$PUPPET_MASTER_FQDN" >> /etc/puppet/puppet.conf;
echo "pluginsync=true" >> /etc/puppet/puppet.conf;
echo "autosign=true" >> /etc/puppet/puppet.conf;
echo "logdir=/var/log/puppet" >> /etc/puppet/puppet.conf;
echo "vardir=/var/lib/puppet" >> /etc/puppet/puppet.conf;
echo "ssldir=/var/lib/puppet/ssl" >> /etc/puppet/puppet.conf;
echo "rundir=/var/run/puppet" >> /etc/puppet/puppet.conf;
echo "factpath=\$vardir/lib/facter" >> /etc/puppet/puppet.conf;
echo "templatedir=\$confdir/templates" >> /etc/puppet/puppet.conf;
echo "prerun_command=/etc/puppet/etckeeper-commit-pre" >> /etc/puppet/puppet.conf;
echo "postrun_command=/etc/puppet/etckeeper-commit-post" >> /etc/puppet/puppet.conf;
