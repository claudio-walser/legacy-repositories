#!/usr/bin/env python3

from lib.Guest.DefaultGuest import DefaultGuest

class Debian(DefaultGuest):

  def getCommandBinary(self):
    return "/bin/bash"
  
  def setHostnameCommand(self):
    shellCode = """
    echo """ + self.getConfig().getHostname() + """ > /etc/hostname

    """
    return shellCode

  def ejectMediaCommand(self):
    shellCode = """
    /usr/bin/apt-get --yes install eject &&
    /usr/bin/eject || 
    exit 0
    """
    return shellCode


  # only used from vmware hypervisor, dont like that dependency but i dont have a better idea yet
  def installVmWareToolsCommand(self):
    shellCode = """
    /usr/bin/apt-get --yes purge open-vm-tools
    /bin/mkdir -p /tmp/cdrom;
    /bin/mkdir -p /tmp/vmware-tools;
    /bin/umount /tmp/cdrom;
    /bin/mount /dev/cdrom /tmp/cdrom;
    /bin/cp /tmp/cdrom/VM*tar.gz /tmp/vmware-tools/vmware-tools.tar.gz;
    cd /tmp/vmware-tools/;
    /bin/tar -xzvf vmware-tools.tar.gz;
    cd vmware-tools-distrib;
    /bin/chmod +x vmware-install.pl;
    ./vmware-install.pl -d;
    exit 0
    """
    return shellCode
    