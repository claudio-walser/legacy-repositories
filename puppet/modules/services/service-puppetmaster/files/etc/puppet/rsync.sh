#!/bin/bash

/usr/bin/rsync -av /mnt/hgfs/puppet/manifests /etc/puppet;
/usr/bin/rsync -av /mnt/hgfs/puppet/modules /etc/puppet;
/usr/bin/rsync -av /mnt/hgfs/puppet/Puppetfile /etc/puppet;

cd /etc/puppet/;
/usr/local/bin/librarian-puppet install --verbose --path modules/forge;

exit 0;
