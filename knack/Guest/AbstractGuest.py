#!/usr/bin/env python3

import os
import sys
import errno

from knack.Guest.GuestConfig import GuestConfig
from knack.Hypervisor.AbstractHypervisor import AbstractHypervisor
from knack.Provisioner.Ssh import Ssh

from knack.Exceptions import GuestNoVmwareToolsException
from knack.Exceptions import SshNoPublicKeyException

"""
Class to simply fill with custom attributes used for returning status
"""
class Status:
    pass

"""
Abstract base Guest
"""
class AbstractGuest(GuestConfig):

  knack = False
  hypervisor = False
  ipaddress = "0.0.0.0"

  sshProvisioner = Ssh()

  def setKnack(self, knack):
    self.knack = knack
    return True

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
    status = Status()

    status.code = 0
    status.message = 'Not created'

    if self.hypervisor.isCreated(self):
      status.code = 1
      status.message = 'Stopped'

    if self.hypervisor.isRunning(self):
      status.code = 2
      status.message = 'Running but no VMWareTools installed'

    if self.hypervisor.isInstalled(self):
      status.code = 3
      status.message = 'Running and vmware-tools installed'

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
  def ssh(self, command = False):
    self.ipaddress = self.hypervisor.getGuestIPAddress(self)
    if not command:
      result = self.sshProvisioner.login(self)
    else:
      result = self.sshProvisioner.command(self, command)

    print(result)

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

  def configure(self):
    self.ipaddress = self.hypervisor.getGuestIPAddress(self)
    status = self.status()
    if not status.code == 3:
      raise GuestNoVmwareToolsException("No vmware tools found")

    if not self.sshProvisioner.hasPublicKey(self):
      try:
        self.copyPublicKey()
      except:
        raise

    print("set hostname: %s" % self.setVmHostname())
    print("set Network: %s" % self.setVmNetwork())

    shellScripts = self.getShellScripts()
    if type(shellScripts) == list:
      for shellScript in shellScripts:
        shellScriptContent = ""

        with open(shellScript, 'r') as fileStream:
          shellScriptContent = fileStream.read()
          shellScriptContent = self.knack.knackfile.parser.applyVariablesToString(shellScriptContent)
        
        print("After replacement")
        print (shellScriptContent)


  """
  guest depending
  """
  def setVmHostname(self):
    raise Exception("Not implemented")

  def getVmHostname(self):
    raise Exception("Not implemented")

  def setVmNetwork(self):
    raise Exception("Not implemented")

  def getVmNetwork(self):
    raise Exception("Not implemented")

  def copyPublicKey(self):
    raise Exception("Not implemented")
