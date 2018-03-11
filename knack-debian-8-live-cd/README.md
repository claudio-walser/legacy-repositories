# knack-debian-8-live-cd #
Project to create an debian jessie iso file, usable by knack

# default root password #
Default root password is set here to 1234. You need to have one to execute knack ssh commands on it in some cases. Unfortunately vmware workstation does not support ssh keys yet.
https://github.com/claudio-walser/knack-debian-8-live-cd/blob/master/config/includes.chroot/sbin/do-debian-installation#L333

# open-vm-tools #
As well as the passwort, vmware workstation is not able to execute anything without at least open-vm-tools. If you dont want to do some steps manually, you have to have those as well as the kernel headers one line above.
https://github.com/claudio-walser/knack-debian-8-live-cd/blob/master/config/includes.chroot/sbin/do-debian-installation#L351

# how to build the iso #
On debian systems install live-bild, clone the repo and build the iso:

     
    sudo apt-get install live-build
    git clone https://github.com/claudio-walser/knack-debian-8-live-cd
    cd knack-debian-8-live-cd
    lb config
    lb clean
    sudo lb build
    
    ls -hal ./*.iso
     

