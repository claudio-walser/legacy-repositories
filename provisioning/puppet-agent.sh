#!/bin/bash

# update
apt-get --yes --force-yes update && apt-get --yes --force-yes upgrade;
# install client
apt-get --yes --force-yes install puppet;

# check puppet master host entry
HAS_HOSTS_ENTRY=grep "<% globals.puppet_master_ip %>" /etc/hosts | grep "<% globals.puppet_master_hostname %> <% globals.puppet_master_hostname %>.<% vm-defaults.environment %>.<% vm-defaults.domain %>"
if [ ! $HAS_HOSTS_ENTRY ]; then
    echo "Adding Puppet Master to /etc/hosts"
    echo "<% globals.puppet_master_ip %>       <% globals.puppet_master_hostname %> <% globals.puppet_master_hostname %>.<% vm-defaults.environment %>.<% vm-defaults.domain %>" >> /etc/hosts
fi
