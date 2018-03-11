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

if [ ! -f /etc/init.d/puppet ]; then
  # update
  apt-get --yes --force-yes update && apt-get --yes --force-yes upgrade
  # install client
  apt-get --yes --force-yes install puppet
fi

# check puppet master host entry
grep "<% globals.puppet_master_ip %>" /etc/hosts | grep "puppet <% globals.puppet_master_hostname %> <% globals.puppet_master_hostname %>.<% vm-defaults.environment %>.<% vm-defaults.domain %>"
if [ $? -ne 0 ]; then
    echo "Adding Puppet Master to /etc/hosts"
    echo "<% globals.puppet_master_ip %>       puppet <% globals.puppet_master_hostname %> <% globals.puppet_master_hostname %>.<% vm-defaults.environment %>.<% vm-defaults.domain %>" >> /etc/hosts
fi

grep "server = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding Puppet Master to /etc/puppet/puppet.conf"
    sed -i "s/\[main\]/\[main\]\nserver = <% globals.puppet_master_hostname %>.<% vm-defaults.environment %>.<% vm-defaults.domain %>/g" /etc/puppet/puppet.conf
fi

grep "autosign = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding Puppet Master to /etc/puppet/puppet.conf"
    sed -i "s/\[main\]/\[main\]\nautosign = true/g" /etc/puppet/puppet.conf
fi

grep "pluginsync = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding Puppet Master to /etc/puppet/puppet.conf"
    sed -i "s/\[main\]/\[main\]\npluginsync = true/g" /etc/puppet/puppet.conf
fi

grep "certificate_revocation = " /etc/puppet/puppet.conf
if [ $? -ne 0 ]; then
    echo "Adding Puppet Master to /etc/puppet/puppet.conf"
    sed -i "s/\[main\]/\[main\]\ncertificate_revocation = true/g" /etc/puppet/puppet.conf
fi

grep "\
templatedir" /etc/puppet/puppet.conf
if [ $? -eq 0 ]; then
    echo "Adding Puppet Master to /etc/puppet/puppet.conf"
    sed -i "s/templatedir/basetemplatedir/g" /etc/puppet/puppet.conf
fi



#rm -rf /etc/puppet/modules && ln -s /mnt/hgfs/puppet/modules /etc/puppet/modules
#rm -rf /etc/puppet/manifests && ln -s /mnt/hgfs/puppet/manifests /etc/puppet/manifests