#!/usr/bin/env python3

import os
import errno

from knack.Guest.GuestConfig import GuestConfig
from knack.Hypervisor.AbstractHypervisor import AbstractHypervisor

"""
Abstract base Guest
"""
class AbstractGuest(GuestConfig):

  hypervisor = False
  ipaddress = "0.0.0.0"

  def setHypervisor(self, hypervisor: AbstractHypervisor):
    self.hypervisor = hypervisor
    return True

  def createVmBasePath(self):
    try:
      os.makedirs(self.getVmPath())
    except OSError as exc:
      if exc.errno == errno.EEXIST and os.path.isdir(self.getVmPath()):
        pass
      else: 
        raise




  """
  status: Prints status of this box

    @return string Current Box status
  """ 
  def status(self):
    status = "Not created"
    if self.hypervisor.isCreated(self):
      status = "Stopped"
    if self.hypervisor.isRunning(self):
      status = "Running but no VMWareTools installed"
    if self.hypervisor.isInstalled(self):
      status = "Running and vmware-tools installed"

    return status


  """
  Start box

    @return bool
  """ 
  def start(self):
    self.createVmBasePath()
    self.hypervisor.start(self) 

    return True


  """
  Stop box

    @return bool
  """ 
  def stop(self):
    self.hypervisor.stop(self)

    return True



  """
  Restart box

    @return bool
  """ 
  def restart(self):
    self.hypervisor.restart(self)

    return True


  """
  Ssh into box

    @void
  """ 
  def ssh(self):
    self.ipaddress = self.hypervisor.getGuestIPAddress(self)
    
    print("ssh box " + self.getHostname())

  """
  Provision box

    @void
  """ 
  def provision(self):
    print("provision box " + self.getHostname())


  """
  Destroy box

    @return bool
  """ 
  def destroy(self):
    self.hypervisor.destroy(self)

    return True

