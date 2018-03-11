#!/usr/bin/env python3

import os
from collections import OrderedDict

from knack.Guest.AbstractGuest import AbstractGuest

"""
Debian Guest - Maybe i could rename it to just linux have to try red-hat at some point
"""
class Debian(AbstractGuest):

  def getVmHostname(self, options = ""):
    return self.sshProvisioner.command(self, "hostname %s" % options)

  def setVmHostname(self):
    if not self.getVmHostname("-d") == self.getFQDN():
      self.sshProvisioner.command(self, "hostname %s" % self.getHostname())
      self.sshProvisioner.command(self, "echo %s > /etc/hostname" % self.getHostname())
      self.sshProvisioner.command(self, "sed -i.bak 's/127.0.0.1[ \t]*localhost/127.0.0.1       %s    %s/g' /etc/hosts" % (self.getFQDN(), self.getHostname()))

    return self.getHostname()

  def getVmNetwork(self):
    return self.sshProvisioner.command(self, "cat /etc/network/interfaces")

  # not sure about network in redhat
  def setVmNetwork(self):
    currentNetworkConfig = self.getVmNetwork()
    desiredNetworkConfig = self.__buildNetworkConfig()

    if not currentNetworkConfig.strip() == desiredNetworkConfig:
      return self.sshProvisioner.command(self, "echo \"%s\" > /etc/network/interfaces; invoke-rc.d networking stop; invoke-rc.d networking start" % desiredNetworkConfig, nohup = True)
    return desiredNetworkConfig


  def copyPublicKey(self):
    # only for linux yet, not sure how sshd on windows works, have to see if i try it once maybe
    source = os.path.expanduser(self.publicKey)

    if self.username == "root":
      targetDirectory = "/root/.ssh/"
    else:
      targetDirectory = "/home/%s/.ssh/" % self.username
    
    target = targetDirectory + "authorized_keys"
    
    result = self.hypervisor.ensureDirectory(self, targetDirectory)

    result = self.hypervisor.copyFile(self, source, target)

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

    return networkConfig.strip()