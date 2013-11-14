#!/bin/bash

/bin/rm -rf /etc/puppet/manifests
/bin/ln -s /mnt/hgfs/puppet/manifests /etc/puppet;

/bin/rm -rf /etc/puppet/modules
/bin/ln -s /mnt/hgfs/puppet/modules /etc/puppet;

/bin/rm -rf /etc/puppet/Puppetfile
/bin/ln -s /mnt/hgfs/puppet/Puppetfile /etc/puppet;

cd /etc/puppet/;
/usr/local/bin/librarian-puppet install --verbose --path modules/forge;

exit 0;
