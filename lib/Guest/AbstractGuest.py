#!/usr/bin/env python3

import os
import errno

from lib.Guest.GuestConfig import GuestConfig
from lib.Interface.AbstractInterface import AbstractInterface
from lib.Hypervisor.AbstractHypervisor import AbstractHypervisor

"""
Abstract base Guest
"""
class AbstractGuest(GuestConfig):

  interface = False
  hypervisor = False

  def setInterface(self, interface: AbstractInterface):
    self.interface = interface
    return True

  def setHypervisor(self, hypervisor: AbstractHypervisor):
    self.hypervisor = hypervisor
    return True

  def createVmBasePath(self):
    try:
      os.makedirs(self.getVmPath())
    except OSError as exc: # Python >2.5
      if exc.errno == errno.EEXIST and os.path.isdir(self.getVmPath()):
        pass
      else: 
        raise

  """
  Show box status

    @void
  """ 
  def status(self):
    raise Exception("Not implemented")
 
  """
  Start box

    @void
  """ 
  def start(self):
    raise Exception("Not implemented") 

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

