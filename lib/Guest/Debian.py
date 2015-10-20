#!/usr/bin/env python3

from lib.Guest.AbstractGuest import AbstractGuest

"""
Debian Guest
"""
class Debian(AbstractGuest):


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
    self.interface.writeOut(self.getHostname().ljust(30) + status)

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
    raise Exception("Not implemented")

  """
  Restart box

    @void
  """ 
  def restart(self):
    raise Exception("Not implemented")

  """
  Ssh into box

    @void
  """ 
  def ssh(self):
    raise Exception("Not implemented")

  """
  Provision box

    @void
  """ 
  def provision(self):
    raise Exception("Not implemented")

  """
  Destroy box

    @void
  """ 
  def destroy(self):
    raise Exception("Not implemented")

