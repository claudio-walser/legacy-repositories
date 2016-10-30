## gpgp ##
gpg --keyserver keyring.debian.org --send-keys 7F17F8BE
gpg --armor --output /var/repositories/apt.uwd.ch.gpg.key --export 56D473C1

## packaging ##
cd ~/packages
fpm -s dir -t deb -v 1.0.0 -a amd64 -n uwd-client-keys uwd-client-keys/authorized_keys=/home/admin/.ssh/ uwd-client-keys/fullchain.pem=/etc/ssl/certificates/suricata.uwd.ch/
fpm -s dir -t deb -v 1.0.0 -a i386 -n uwd-client-keys uwd-client-keys/authorized_keys=/home/admin/.ssh/ uwd-client-keys/fullchain.pem=/etc/ssl/certificates/suricata.uwd.ch/
fpm -s dir -t deb -v 1.0.0 -a armhf -n uwd-client-keys uwd-client-keys/authorized_keys=/home/admin/.ssh/ uwd-client-keys/fullchain.pem=/etc/ssl/certificates/suricata.uwd.ch/
reprepro -b /var/repositories includedeb jessie *.deb
reprepro -b /var/repositories/ list jessie

## installation ##
wget -O - -q https://apt.uwd.ch/apt.uwd.ch.gpg.key | apt-key add -

sources.list
deb https://apt.uwd.ch/ jessie main


## what to package ##
-Authorized Keys and ES fullchain.pem
-Suricata Rules