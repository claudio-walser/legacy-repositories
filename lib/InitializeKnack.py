#!/usr/bin/env python3

import os

from lib.ConfigDefaults import ConfigDefaults
from lib.Exceptions import KnackfileAlreadyFoundException
from lib.Interface.AbstractInterface import AbstractInterface

from lib.Knackfile import Knackfile

"""
This is the AbstractKnack class, trying to load .Knackfile
and providing other main functionality of the program. 

@abstract
"""
class InitializeKnack(object):
  
  """
  Config to write
  """ 
  config = {}

  """
  Helper object for getting default configs
  """ 
  configDefaults = ConfigDefaults()

  """
  Constructor: Instantiate Knackfile and load yaml config

    @arg interface:str        The Interface type you currently work with, default "cli"
    @void
  """ 
  def __init__(self):
    if os.path.isfile("./.Knackfile"):
      raise KnackfileAlreadyFoundException(".Knackfile already exists")

  """
  askDefaults: Start asking default values with interface object

    @arg interface:AbstractInterface        The Interface type you currently work with, default "cli"
    @void
  """ 
  def askDefaults(self, interface: AbstractInterface):
    hypervisor = interface.askFor("What hypervisor you want to use?", self.configDefaults.getHypervisors(), self.configDefaults.getDefaultHypervisor())
    basePath = interface.askFor("What is the base path you want to store your boxes?", "os.directory", os.getcwd() + "/.knack-boxes")
    guest = interface.askFor("What guest you want to install?", self.configDefaults.getGuests(), self.configDefaults.getDefaultGuest())
    installMedium = interface.askFor("What is the install medium you gonna use for setup your box?", "os.directory", os.getcwd() + "/" + guest + ".live.iso")

    boxName = interface.askFor("What is the name of your box?", False, "box")
    boxDomain = interface.askFor("What is the domain of your box?", False, "default.com")
    boxEnvironment = interface.askFor("What is the environment of your box?", False, "dev")

    boxCpu = interface.askFor("How many cpu's you want to use?", False, "1")
    boxMemory = interface.askFor("What memory size you want to use?", False, "1024")
    boxDiskSize = interface.askFor("What disk size you want to use?", False, "10GB")

    # put minimal config dict together
    self.config = {
      'hypervisor': hypervisor,
      'vm-defaults': {
        'guest_os': guest,
        'hostname': 'default',
        'environment': boxEnvironment,
        'domain': boxDomain,
        'base_path': basePath,
        'install_medium': installMedium,
        'hardware': {
          'cpu': boxCpu,
          'memory': boxMemory,
          'disk': boxDiskSize
        },
        'network': {
          'eth0': 'dhcp'
        }
      },

      'boxes': {
        boxName: {
          'hostname': boxName
        }
      }
    }

  """
  writeConfig: Writes config object to yaml file

    @return   bool  True if file has been written otherwise False
  """ 
  def writeConfig(self):
    # write .Knackfile
    knackfile = Knackfile()
    written = knackfile.write(self.config)

    return written
   