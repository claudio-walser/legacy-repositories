#!/bin/bash


if [ ! -f /etc/apt/sources.list.d/puppetlabs.list ]; then
    echo "Adding puppetlabs repo"
    # write puppetlabs apt list
    echo "# Puppetlabs products" > /etc/apt/sources.list.d/puppetlabs.list
    echo "deb http://apt.puppetlabs.com wheezy main" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "deb-src http://apt.puppetlabs.com wheezy main" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "# Puppetlabs dependencies" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "deb http://apt.puppetlabs.com wheezy dependencies" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "deb-src http://apt.puppetlabs.com wheezy dependencies" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "# Puppetlabs devel (uncomment to activate)" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "# deb http://apt.puppetlabs.com wheezy devel" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "# deb-src http://apt.puppetlabs.com wheezy devel" >> /etc/apt/sources.list.d/puppetlabs.list
    echo "" >> /etc/apt/sources.list.d/puppetlabs.list

    # add puppetlabs gpg
    gpg --keyserver pgpkeys.mit.edu --recv-key  1054B7A24BD6EC30
    gpg -a --export 1054B7A24BD6EC30 | apt-key add -
fi

if [ ! -f /etc/init.d/puppetmaster ]; then
    apt-get --yes --force-yes install puppetmaster
fi

if [ ! -h /etc/puppet/modules ]; then
    rm -rf /etc/puppet/modules && ln -s /mnt/hgfs/puppet/modules /etc/puppet/modules
fi

if [ ! -h /etc/puppet/manifests ]; then
    rm -rf /etc/puppet/manifests && ln -s /mnt/hgfs/puppet/manifests /etc/puppet/manifests
fi

if [ ! -d /etc/puppet/environments/production ]; then
    mkdir -p /etc/puppet/environments/production
fi

if [ ! -h /etc/puppet/environments/production/manifests ]; then
    rm -rf /etc/puppet/environments/production/manifests
    ln -s /mnt/hgfs/puppet/manifests /etc/puppet/environments/production/manifests
fi

grep "basemodulepath = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding basemodulepath to /etc/puppet/puppet.conf"
    #echo "basemodulepath = /etc/puppet/modules/roles:/etc/puppet/modules/profiles:/etc/puppet/modules/services:/etc/puppet/modules/forge" >> /etc/puppet/puppet.conf
    sed -i "s/\[master\]/\[master\]\nbasemodulepath = \/etc\/puppet\/modules\/roles:\/etc\/puppet\/modules\/profiles:\/etc\/puppet\/modules\/services:\/etc\/puppet\/modules\/forge/g" /etc/puppet/puppet.conf
fi

grep "environmentpath = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding environmentpath to /etc/puppet/puppet.conf"
    #echo "basemodulepath = /etc/puppet/modules/roles:/etc/puppet/modules/profiles:/etc/puppet/modules/services:/etc/puppet/modules/forge" >> /etc/puppet/puppet.conf
    sed -i "s/\[master\]/\[master\]\nenvironmentpath = \$confdir\/environments/g" /etc/puppet/puppet.conf
fi

#rm -rf /etc/puppet/modules && ln -s /mnt/hgfs/puppet/modules /etc/puppet/modules
#rm -rf /etc/puppet/manifests && ln -s /mnt/hgfs/puppet/manifests /etc/puppet/manifests

#basemodulepath = /etc/puppet/modules/roles:/etc/puppet/modules/profiles:/etc/puppet/modules/services:/etc/puppet/modules/forge
#echo "basemodulepath = /etc/puppet/modules/roles:/etc/puppet/modules/profiles:/etc/puppet/modules/services:/etc/puppet/modules/forge" >> /etc/puppet/puppet.conf