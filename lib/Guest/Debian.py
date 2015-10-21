#!/usr/bin/env python3

import os
import subprocess

from lib.Guest.AbstractGuest import AbstractGuest

"""
Debian Guest
"""
class Debian(AbstractGuest):

  ipaddress = "0.0.0.0"

  """
  status: Prints status of this box

    @return True
  """ 
  def status(self):
    status = "Not created"
    if self.hypervisor.isCreated(self):
      status = "Stopped"
    if self.hypervisor.isRunning(self):
      status = "Running but no VMWareTools installed"
    if self.hypervisor.isInstalled(self):
      status = "Running and vmware-tools installed"

    # just print the status
    self.interface.writeOut(self.getName().ljust(30) + status)

    return True



  """
  Start box

    @void
  """ 
  def start(self):
    self.createVmBasePath()
    self.hypervisor.start(self) 

  """
  Stop box

    @void
  """ 
  def stop(self):
    self.hypervisor.stop(self)

  """
  Restart box

    @void
  """ 
  def restart(self):
    self.hypervisor.restart(self)

  """
  Ssh into box

    @void
  """ 
  def ssh(self):
    self.ipaddress = self.hypervisor.getGuestIPAddress(self)
    if not self.hasPublicKey():
      self.copyPublicKey()

    if self.__ssh("hostname") != self.getHostname():
      self.__ssh("hostname %s" % self.getHostname())

    print(self.__ssh("hostname"))


  def __ssh(self, command):
    host = self.username + "@" + self.ipaddress
    ssh = subprocess.Popen(["ssh", "%s" % host, command],
                       shell=False,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()
    if result == []:
      print("Error")
      return False
    else:
      return result[0].decode("utf-8").strip()

  """
  Provision box

    @void
  """ 
  def provision(self):
    print("provision box " + self.getHostname())

  """
  Destroy box

    @void
  """ 
  def destroy(self):
    self.hypervisor.destroy(self)




  # should do that maybe in a seperate ssh class
  def copyPublicKey(self):
    source = os.path.expanduser(self.publicKey)

    if self.username == "root":
      targetDirectory = "/root/.ssh/"
    else:
      targetDirectory = "/home/%s/.ssh/" % self.username
    
    target = targetDirectory + "authorized_keys"
    
    self.hypervisor.ensureDirectory(self, targetDirectory)
    self.hypervisor.copyFile(self, source, target)

  def hasPublicKey(self):
    host = self.username + "@" + self.ipaddress
    ssh = subprocess.Popen(["ssh", "-o PasswordAuthentication=no ", "%s" % host, "whoami"],
                       shell=False,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()
    if result == []:
      return False
    else:
      return True