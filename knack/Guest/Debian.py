#!/usr/bin/env python3

import sys
from collections import OrderedDict

from knack.Guest.AbstractGuest import AbstractGuest

"""
Debian Guest - Maybe i could rename it to just linux have to try red-hat at some point
"""
class Debian(AbstractGuest):

  def getVmHostname(self, options = ""):
    return self.sshProvisioner.command(self, "hostname %s" % options)

  def setVmHostname(self):
    if self.getVmHostname("-d") == "%s.%s" % (self.getHostname(), self.getDomain()):
      return True
    #try:
    self.sshProvisioner.command(self, "hostname %s" % self.getHostname())
    self.sshProvisioner.command(self, "echo %s > /etc/hostname" % self.getHostname())
    self.sshProvisioner.command(self, "sed -i.bak 's/127.0.0.1[ \t]*localhost/127.0.0.1       %s    %s/g' /etc/hosts" % (self.getFQDN(), self.getHostname()))
    
    return "goddammit"
    #  return True
    #except:
    #  raise
    #  return False

  def getVmNetwork(self):
    return self.sshProvisioner.command(self, "cat /etc/network/interfaces")

  # not sure about network in redhat
  def setVmNetwork(self):
    currentNetworkConfig = self.getVmNetwork()
    desiredNetworkConfig = self.__buildNetworkConfig()

    if not currentNetworkConfig.strip() == desiredNetworkConfig:
      return self.sshProvisioner.command(self, "echo \"%s\" > /etc/network/interfaces && service networking restart && exit" % desiredNetworkConfig)
    return False


  def copyPublicKey(self):
    # only for linux yet, not sure how sshd on windows works, have to see if i try it once maybe
    source = os.path.expanduser(self.publicKey)

    if self.username == "root":
      targetDirectory = "/root/.ssh/"
    else:
      targetDirectory = "/home/%s/.ssh/" % self.username
    
    target = targetDirectory + "authorized_keys"
    
    self.hypervisor.ensureDirectory(self, targetDirectory)
    self.hypervisor.copyFile(self, source, target)


  """
  Private methods
  """

  def __buildNetworkConfig(self):
    networkConfig = """\
auto lo
iface lo inet loopback

"""

    interfaces = self.getNetworkInterfaces()
    for interface in sorted(interfaces.keys()):
      
      if type(interfaces[interface]) == str and interfaces[interface].lower() == "dhcp":
        networkConfig += """\
auto %s
iface %s inet dhcp

""" % (interface, interface)

      print(type(interfaces[interface]))
      #{'ip': '10.20.0.2', 'gateway': '10.20.0.1', 'netmask': '255.255.255.0'}
      if type(interfaces[interface]) == dict and \
         "ip" in interfaces[interface] and \
         "netmask" in interfaces[interface] and \
         "gateway" in interfaces[interface]:

         networkConfig += """\
auto %s
iface %s inet static
  address %s
  netmask %s
  gateway %s

""" % (interface, interface, interfaces[interface]["ip"], interfaces[interface]["netmask"], interfaces[interface]["gateway"])


      #print(interface)
      #print(interfaces[interface])

    return networkConfig.strip()