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
    print("you have chosen: " + hypervisor)
