#!/usr/bin/env python3

"""
Config Defaults for .Knackfile.
"""
class ConfigDefaults(object):

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