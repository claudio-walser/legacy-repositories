#!/usr/bin/env python3

from knack.AbstractKnack import AbstractKnack
from knack.Knackfile.Initialize import Initialize

from knack.Exceptions import GuestNoVmwareToolsException
from knack.Exceptions import SshNoPublicKeyException

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
   

  def configure(self, boxes):
    self.interface.header("Configure")

    boxes = self.getBoxList(boxes)
    
    for box in boxes:
      guest = self.getGuestObject(box)
      try:
        guest.configure()
      except GuestNoVmwareToolsException:
        self.interface.error("%s %s \nBox not ready yet, get it up and running, then ensure vmware-tools are running as well" % (guest.getName().ljust(30), guest.status().code))
      except SshNoPublicKeyException:
        self.interface.error("%s %s \nBox ready but i do have problems to copy your public key" % (guest.getName().ljust(30), guest.status().code))

      #guest.
      #guest.setHostname()   

  """
  Show box status

    @void
  """ 
  def status(self, boxes):
    self.interface.header("Status")

    boxes = self.getBoxList(boxes)
    
    for box in boxes:
      guest = self.getGuestObject(box)
      self.interface.writeOut(guest.getName().ljust(30) + guest.status().message)


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


