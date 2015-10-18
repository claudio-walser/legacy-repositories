#!/usr/bin/env python3

import os

from lib.ConfigDefaults import ConfigDefaults
from lib.Exceptions import InitializeKnackfileAlreadyFoundException
from lib.Interface.AbstractInterface import AbstractInterface

"""
This is the AbstractKnack class, trying to load .Knackfile
and providing other main functionality of the program. 

@abstract
"""
class InitializeKnack(object):
  
  '''
  vm-defaults:
  user: root
  pass: 1234
  guest_os: debian8-64
  hostname: debian-01
  environment: development
  domain: claudio.dev
  base_path: ~/Development/VMWare/VirtualMachines
  install_medium: ~/Development/VMWare/Isos/live-image-amd64.hybrid.iso
  shared_folders:
    - ./provisioning
  copyFiles:
    authorized_keys:
      source: ~/Development/VMWare/Authentication/authorized_keys
      target: /root/.ssh/authorized_keys
  hardware:
    cpu: 1
    memory: 1024
    disk: 10GB
  network:
    eth0: dhcp
    eth1: dhcp
  '''



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
      raise InitializeKnackfileAlreadyFoundException(".Knackfile already exists")

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



    interface.ok("Given answers: ")
    print("hypervisor: " + hypervisor)
    print("basePath: " + basePath)
    print("guest os: " + guest)
    print("install medium: " + installMedium)
 

    print("box name: " + boxName)
    print("box domain: " + boxDomain)
    print("box environment: " + boxEnvironment)

    print("box cpu: " + boxCpu)
    print("box memory: " + boxMemory)
    print("box disk size: " + boxDiskSize)
