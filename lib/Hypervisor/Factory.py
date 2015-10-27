#!/usr/bin/env python3

from lib.Hypervisor.VmwareWorkstation import VmwareWorkstation

"""
Hypervisor Factory, creates the right hypervisor object.
"""
class Factory(object):


  """
  Create Hypervisor object
  """ 
  def create(hypervisor: str):

    if hypervisor == "vmware-workstation":
      return VmwareWorkstation()

    return False