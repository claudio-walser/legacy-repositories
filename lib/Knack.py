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
    if initialize.writeConfig():
      self.interface.ok('.Knackfile successfully written')
    else:
      self.interface.error('Could not write .Knackfile. Check folder permissions in ' + os.getcwd())
    

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
    boxes = self.getBoxList(boxes)
    self.interface.header("Stop")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.stop()


  """
  Restart box

    @void
  """ 
  def restart(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Restart")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.restart()



  """
  Ssh into box

    @void
  """ 
  def ssh(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Ssh")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.ssh()



  """
  Provision box

    @void
  """ 
  def provision(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Provision")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.provision()



  """
  Destroy box

    @void
  """ 
  def destroy(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Destroy")
    for box in boxes:
      guest = self.getGuestObject(box)
      guest.destroy()


