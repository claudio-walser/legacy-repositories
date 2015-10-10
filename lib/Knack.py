#!/usr/bin/env python3

import importlib

from lib.ConfigParser import ConfigParser
from lib.hypervisor.VmwareWorkstation import VmwareWorkstation
from lib.Box import Box
from pprint import pprint

class Knack(object):
  
  box = False
  hypervisor = False
  allowedHypervisors = {'vmware-workstation': 'lib.hypervisor.VmwareWorkstation'}
  parser = False
  knackConfig = {}


  def __init__(self, boxName):
   self.__loadConfigFile(boxName)   

  def __loadConfigFile(self, boxName):
    self.parser = ConfigParser()
    self.parser.load()
    boxConfig = self.parser.getConfigForBox(boxName)

    self.box = Box(boxConfig)
    self.hypervisor = self.__instantiateHypervisor()
    #self.hypervisor.setBox(self.box)


  def __instantiateHypervisor(self):
    return VmwareWorkstation()


  # accessible knack actions
  #start|stop|restart|ssh|destroy|status
  def start(self):
    self.hypervisor.start(self.box)

  def stop(self):
    # check if box is created
    # check if box is registered
    # check if box is started
    # if yes, stop it now
    print("stop box " + self.box)

  def restart(self):
    # check if box is created, if not throw an error to start it first
    # check if box is registered, if not throw an error to start it first
    # just restart box since hypervisor takes care of stop it if its running
    print("restart box " + self.box)

  def ssh(self):
    # check if box is created, if not throw an error to start it first
    # check if box is registered, if not throw an error to start it first
    # check if box is started, if not throw an error to start it first
    # if yes ssh into it
    print("ssh into box " + self.box)	

  def destroy(self):
    # check if started, if yes stop
    # check if registered, if yes unregister
    # check if created, if yes destroy
    print("destroy box " + self.box)

  def status(self):
    # just read the status
    print("status of box " + self.box)

