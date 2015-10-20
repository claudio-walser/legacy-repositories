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
    print("ssh into box " + self.getHostname())

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

