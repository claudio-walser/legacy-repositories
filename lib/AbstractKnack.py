#!/usr/bin/env python3

from lib.Knackfile import Knackfile
from lib.Interface.Cli import Cli

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
  Constructor: Instantiate Knackfile and load yaml config

    @arg interface:str        The Interface type you currently work with, default "cli"
    @void
  """ 
  def __init__(self, interface: str = "cli"):
    if not self.__setInterface(interface):
      self.interface.error("Interface Type not found, possible interfaces are: " + "|".join(self.interfaces))

    self.loadConfig()
    
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
