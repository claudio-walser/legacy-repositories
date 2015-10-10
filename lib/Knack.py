#!/usr/bin/env python3

import importlib
import os
import errno

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

  def __createVmBasePath(self):
    print(self.box.getVmPath())

    try:
      os.makedirs(self.box.getVmPath())
    except OSError as exc: # Python >2.5
      if exc.errno == errno.EEXIST and os.path.isdir(self.box.getVmPath()):
        pass
      else: 
        raise

  def __loadConfigFile(self, boxName):
    self.parser = ConfigParser()
    self.parser.load()
    boxConfig = self.parser.getConfigForBox(boxName)

    self.box = Box(boxConfig)
    self.hypervisor = self.__instantiateHypervisor()
    self.__createVmBasePath()
    

  def __instantiateHypervisor(self):
    return VmwareWorkstation()


  # accessible knack actions
  #start|stop|restart|ssh|destroy|status
  def start(self):
    self.hypervisor.start(self.box)

  def stop(self):
    self.hypervisor.stop(self.box)

  def restart(self):
    self.hypervisor.restart(self.box)

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

