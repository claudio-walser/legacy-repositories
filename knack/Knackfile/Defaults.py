#!/usr/bin/env python3

"""
Config Defaults for .Knackfile.
"""
class Defaults(object):

  """
  getHypervisors: Get possible hypervisors

    @return list  List of all possible hypervisors
  """ 
  def getHypervisors(self):
    return ["vmware-workstation"]

  """
  getDefaultHypervisor: Get the default hypervisor

    @return str  Default hypervisor as string
  """ 
  def getDefaultHypervisor(self):
    return self.getHypervisors()[0]

  """
  getHypervisors: Get possible guest systems

    @return list  List of all possible guest systems
  """ 
  def getGuests(self):
    return ["debian7-64", "debian8-64"]

  """
  getDefaultHypervisor: Get the default guest

    @return str  Default hypervisor as string
  """ 
  def getDefaultGuest(self):
    return self.getGuests()[0]