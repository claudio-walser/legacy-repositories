#!/usr/bin/env python3


import sys

from lib.Knackfile import Knackfile
from lib.Interface.Cli import Cli
from lib.Exceptions import KnackfileNotFoundException


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
  interface: str Default Interface - default first list-entry of self.interfaces
  """ 
  interface = Cli()


  """
  Constructor: Instantiate Knackfile and load yaml config

    @void
  """ 
  def __init__(self, interface: str = "cli"):
    if not self.__setInterface(interface):
      self.interface.error("Interface Type not found, possible interfaces are: " + "|".join(self.interfaces))

    try:
      self.knackfile.load()
    except KnackfileNotFoundException:
      self.interface.error("No .Knackfile found. Aborting!")


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
    @arg interface:str    Interface you want to work with
    @return bool          True if given interface can be used, False otherwise
  """
  def __setInterface(self, interface: str):
    if not interface in self.interfaces:
      return False

    self.interface = Cli()
    return True
