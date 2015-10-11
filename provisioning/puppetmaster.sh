#!/bin/bash


usage() {
    echo "
    usage: $0 options

    This script set up a puppet master

    OPTIONS:

       -?	   This help
    ";

    exit;
}

while getopts “p:?” OPTION
do
     case $OPTION in
        ?)
            usage;
            ;;
     esac
done


# move config there are some cases were puppetmaster makes problem
mv /etc/puppet/puppet.conf /etc/puppet/puppet.conf.bu;

# write puppetlabs apt list
echo "# Puppetlabs products" > /etc/apt/sources.list.d/puppetlabs.list;
echo "deb http://apt.puppetlabs.com jessie main" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "deb-src http://apt.puppetlabs.com jessie main" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "# Puppetlabs dependencies" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "deb http://apt.puppetlabs.com jessie dependencies" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "deb-src http://apt.puppetlabs.com jessie dependencies" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "# Puppetlabs devel (uncomment to activate)" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "# deb http://apt.puppetlabs.com jessie devel" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "# deb-src http://apt.puppetlabs.com jessie devel" >> /etc/apt/sources.list.d/puppetlabs.list;
echo "" >> /etc/apt/sources.list.d/puppetlabs.list;

# add puppetlabs gpg
gpg --keyserver pgpkeys.mit.edu --recv-key  1054B7A24BD6EC30;
gpg -a --export 1054B7A24BD6EC30 | apt-key add -;


# install puppet master
apt-get update;
apt-get --yes --force-yes install puppetmaster;
apt-get --yes --force-yes install hiera-puppet;
apt-get --yes --force-yes install puppetdb puppetdb-terminus;
apt-get --yes --force-yes install ruby-dev git;
gem install librarian-puppet;


# move puppet config back and add master settings
rm /etc/puppet/puppet.conf;
mv /etc/puppet/puppet.conf.bu /etc/puppet/puppet.conf;
echo "" >> /etc/puppet/puppet.conf;
echo "[master]" >> /etc/puppet/puppet.conf;
echo "  # These are needed when the puppetmaster is run by passenger" >> /etc/puppet/puppet.conf;
echo "  # and can safely be removed if webrick is used." >> /etc/puppet/puppet.conf;
echo "  ssl_client_header = SSL_CLIENT_S_DN " >> /etc/puppet/puppet.conf;
echo "  ssl_client_verify_header = SSL_CLIENT_VERIFY" >> /etc/puppet/puppet.conf;
echo "" >> /etc/puppet/puppet.conf;
echo "  # my module paths" >> /etc/puppet/puppet.conf;
echo '  environmentpath = $confdir/environments' >> /etc/puppet/puppet.conf;
echo "  basemodulepath=/etc/puppet/modules/roles:/etc/puppet/modules/profiles:/etc/puppet/modules/services:/etc/puppet/modules/forge" >> /etc/puppet/puppet.conf;
[master]
    certname = puppet
    autosign = true
    environmentpath = $confdir/environments
    basemodulepath = /etc/puppet/modules/role:/etc/puppet/modules/profile:/etc/puppet/modules/module:/etc/puppet/modules/forge:/etc/puppet/modules/platform-services
    environment_timeout = unlimited
    reports = puppetdb
    storeconfigs = true
    storeconfigs_backend = puppetdb

[agent]
runinterval = 30m
splay = true
configtimeout = 5m
usecacheonfailure = true
report = true

[main]
ssldir = /var/lib/puppet/ssl







# remove default puppet files
rm -rf /etc/puppet/manifests;
rm -rf /etc/puppet/modules;
rm -rf /etc/puppet/hieradata;
rm -rf /etc/puppet/Puppetfile;

# symlink puppet files
ln -s /mnt/hgfs/puppet/manifests /etc/puppet/manifests;
ln -s /mnt/hgfs/puppet/modules /etc/puppet/modules;
ln -s /mnt/hgfs/puppet/hieradata /etc/puppet/hieradata;
ln -s /mnt/hgfs/puppet/Puppetfile /etc/puppet/Puppetfile;

# load forge modules
cd /etc/puppet/;
/usr/local/bin/librarian-puppet install --verbose --path modules/forge;

# restart doesent work here properly for some reason
service puppetmaster stop;
service puppetmaster start;