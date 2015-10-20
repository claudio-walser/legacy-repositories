#!/usr/bin/env python3

from lib.AbstractKnack import AbstractKnack
from lib.InitializeKnack import InitializeKnack


"""
Concrete Knack implementation.
In best case, this class should only contain callable actions.
Main functionality is coming from AbstractKnack.

@extends lib.AbstractKnack.AbstractKnack
"""
class Knack(AbstractKnack):


  """
  Initialize a new config file.

    @void
  """ 
  def init(self, boxes):
    self.interface.header("Initialize")
    self.interface.writeOut("")
    initialize = InitializeKnack()
    initialize.askDefaults(self.interface)
    

  """
  Show box status

    @void
  """ 
  def status(self, boxes):
    self.interface.header("Status")

    boxes = self.getBoxList(boxes)
    
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.status()
 


  """
  Start box

    @void
  """ 
  def start(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Start")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.start()


  """
  Stop box

    @void
  """ 
  def stop(self, boxes):
    boxList = self.getBoxList(boxes)
    self.interface.header("Stop")
    print("lib.Knack.stop " + ", ".join(boxList)) 


  """
  Restart box

    @void
  """ 
  def restart(self, boxes):
    boxList = self.getBoxList(boxes)
    self.interface.header("Restart")
    print("lib.Knack.restart " + ", ".join(boxList)) 


  """
  Ssh into box

    @void
  """ 
  def ssh(self, boxes):
    boxList = self.getBoxList(boxes)
    self.interface.header("Ssh")
    print("lib.Knack.ssh " + ", ".join(boxList)) 


  """
  Provision box

    @void
  """ 
  def provision(self, boxes):
    boxList = self.getBoxList(boxes)
    self.interface.header("Provision")
    print("lib.Knack.provision " + ", ".join(boxList)) 


  """
  Destroy box

    @void
  """ 
  def destroy(self, boxes):
    boxList = self.getBoxList(boxes)
    self.interface.header("Provision")
    print("lib.Knack.destroy " + ", ".join(boxList)) 

