#!/usr/bin/env python3

from knack.AbstractKnack import AbstractKnack
from knack.Knackfile.Initialize import Initialize


"""
Concrete Knack implementation.
In best case, this class should only contain callable actions.
Main functionality is coming from AbstractKnack.

@extends knack.AbstractKnack.AbstractKnack
"""
class Knack(AbstractKnack):


  """
  Initialize a new config file.

    @void
  """ 
  def init(self, boxes):
    self.interface.header("Initialize")
    self.interface.writeOut("")
    initialize = Initialize()
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
      self.interface.writeOut(guest.getName().ljust(30) + guest.status())


  """
  Start box

    @void
  """ 
  def start(self, boxes):
    boxes = self.getBoxList(boxes)
    self.interface.header("Start")
    for box in boxes:
      guest = self.getGuestObject(box)
      self.interface.writeOut(guest.getName().ljust(30) + "starting...")
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
      self.interface.writeOut(guest.getName().ljust(30) + "stopping...")
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
      self.interface.writeOut(guest.getName().ljust(30) + "restarting...")
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
      self.interface.writeOut(guest.getName().ljust(30) + "establish ssh connection...")
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
      self.interface.writeOut(guest.getName().ljust(30) + "provision...")
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
      # ask user first maybe
      self.interface.writeOut(guest.getName().ljust(30) + "destroying...")
      guest.destroy()


