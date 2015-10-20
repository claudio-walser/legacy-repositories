#!/usr/bin/env python3

import pprint

from lib.Knackfile import Knackfile
from lib.Interface.Cli import Cli
from lib.HypervisorFactory import HypervisorFactory
from lib.GuestFactory import GuestFactory

"""
This is the AbstractKnack class, trying to load .Knackfile
and providing other main functionality of the program. 

@abstract
"""
class AbstractKnack(object):
  
  """
  knackfile: lib.Knackfile.Knackfile Instance for easy yaml loading
  """ 
  knackfile = Knackfile()

  """
  interfaces: list Possible interfaces for this program, right now its just command line
  """ 
  interfaces = ["cli"]

  """
  interface: lib.Interface.AbstractInterface.AbstractInterface Default Interface - default Cli
  """ 
  interface = Cli()

  """
  hypervisor: lib.Hypervisor.AbstractHypervisor.AbstractHypervisor Hypervisor object to work with
  """
  hypervisor = False
  """
  Constructor: Instantiate Knackfile and load yaml config

    @arg interface:str        The Interface type you currently work with, default "cli"
    @void
  """ 
  def __init__(self, interface: str = "cli"):
    if not self.__setInterface(interface):
      self.interface.error("Interface Type not found, possible interfaces are: " + "|".join(self.interfaces))

    self.loadConfig()
    self.loadHypervisor()

  """
  loadHypervisor: Load Hypervisor object defined in config

    @raise  Exception   Raises an exception if no config loaded yet
    @raise  Exception   Raises an exception if no hypervisor found in config
    @return bool        Returns true
  """ 
  def loadHypervisor(self):
    if not self.knackfile.loaded:
      raise Exception("No config loaded yet.")

    if not self.knackfile.getConfigByNamespace("hypervisor"):
      raise Exception("No hypervisor found in config")

    self.hypervisor =  HypervisorFactory.create(self.knackfile.getConfigByNamespace("hypervisor"))
    return True

  """
  loadConfig: Load yaml config

    @return bool    Returns true or false, whether the file has been loaded or not
  """ 
  def loadConfig(self):
    try:
      self.knackfile.load()
      return True
    except:
      return False


  """
  getActions: Returns a list of all implemented actions.

    @return list          List of all implemented actions
  """
  def getActions(self):
    return ["init", "status", "start", "stop", "restart", "ssh", "provision", "destroy"]


  """
  getBoxList: Makes a list of a given box-param. Displays an error if the box does not exist,
              fetches all possible boxes from config in case of wildcard <*> is given.

    @arg box:str          The box you want to listify
    @return list          List of given box or of all boxes in case of wildcard
  """
  def getBoxList(self, box: str):
    if  box == "*":
      boxes = self.knackfile.getAllBoxNames()
    elif not self.knackfile.hasBox(box):
      self.interface.error("Box with name <" + box + "> is not present. Check in your .Knackfile!")
    else:
      boxes = [box]

    return boxes 

  """
  getGuestObjectDict: Instantiates a Guest object from given boxname.

    @arg box:str                      The box you want to create a guest object from
    @raise Exception                  Raises an exception if boxname could not be found in .Knackfile
    @return lib.Guest.AbstractGuest   Finalized guest object
  """
  def getGuestObject(self, box: str):
    if self.knackfile.hasBox(box):
      boxConfig = self.knackfile.getConfigForBox(box)
    else:
      raise Exception("Boxname " + box + " not found in .Knackfile")
    
    guest = GuestFactory.create(boxConfig)
    guest.setName(box)
    guest.setHypervisor(self.hypervisor)
    guest.setInterface(self.interface)
    
    return guest

  """
  __setInterface: Sets a given interface if it exists

    @private 
    @arg interface:str        Interface you want to work with
    @return bool              True if given interface can be used, False otherwise
  """
  def __setInterface(self, interface: str):
    if not interface in self.interfaces:
      return False

    self.interface = Cli()
    return True
