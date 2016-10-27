## gpgp ##
gpg --keyserver keyring.debian.org --send-keys 7F17F8BE

## packaging ##
cd ~/packages
fpm -s dir -t deb -v 1.0.0 -n uwd-client-keys ./uwd-client-keys/authorized_keys=/home/admin/.ssh ./uwd-client-keys/fullchain.pem=/etc/ssl/
mv uwd-client-keys_1.0.0_amd64.deb /tmp/debs/
reprepro -b /var/repositories includedeb jessie /tmp/debs/uwd-client-keys_1.0.0_amd64.deb
reprepro -b /var/repositories/ list jessie

## installation ##

