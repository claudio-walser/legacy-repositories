#!/bin/bash


# install puppet master
apt-get --yes install puppetmaster;

# remove default puppet files
rm -rf /etc/puppet/manifests;
rm -rf /etc/puppet/modules;

# rsync hosts puppet files
rsync -av /mnt/hgfs/puppet/manifests/ /etc/puppet/manifests/;
rsync -av /mnt/hgfs/puppet/modules/ /etc/puppet/modules/;

# correct configs for my setup
echo "[main]" > /etc/puppet/puppet.conf
echo "pluginsync=true" >> /etc/puppet/puppet.conf
echo "autosign=true" >> /etc/puppet/puppet.conf
echo "logdir=/var/log/puppet" >> /etc/puppet/puppet.conf
echo "vardir=/var/lib/puppet" >> /etc/puppet/puppet.conf
echo "ssldir=/var/lib/puppet/ssl" >> /etc/puppet/puppet.conf
echo "rundir=/var/run/puppet" >> /etc/puppet/puppet.conf
echo "factpath=$vardir/lib/facter" >> /etc/puppet/puppet.conf
echo "templatedir=$confdir/templates" >> /etc/puppet/puppet.conf
echo "prerun_command=/etc/puppet/etckeeper-commit-pre" >> /etc/puppet/puppet.conf
echo "postrun_command=/etc/puppet/etckeeper-commit-post" >> /etc/puppet/puppet.conf
echo "" >> /etc/puppet/puppet.conf
echo "[master]" >> /etc/puppet/puppet.conf
echo "# These are needed when the puppetmaster is run by passenger" >> /etc/puppet/puppet.conf
echo "# and can safely be removed if webrick is used." >> /etc/puppet/puppet.conf
echo "ssl_client_header = SSL_CLIENT_S_DN " >> /etc/puppet/puppet.conf
echo "ssl_client_verify_header = SSL_CLIENT_VERIFY" >> /etc/puppet/puppet.conf
echo "" >> /etc/puppet/puppet.conf
echo "# my module path" >> /etc/puppet/puppet.conf
echo "manifestdir=/etc/puppet/manifests" >> /etc/puppet/puppet.conf
echo "modulepath=/etc/puppet/modules/components:/etc/puppet/modules/forge:/etc/puppet/modules/roles:/etc/puppet/modules/services:/etc/puppet/modules/data" >> /etc/puppet/puppet.conf
