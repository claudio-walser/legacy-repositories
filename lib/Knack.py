#!/usr/bin/env python3

# main libs
import importlib
import os
import errno

# config classes
from lib.ConfigParser import ConfigParser
from lib.BoxConfig import BoxConfig

# hypervisors
from lib.Hypervisor.VmwareWorkstation import VmwareWorkstation
# guests
from lib.Guest.Debian import Debian


class Knack(object):
  
  guest = False
  hypervisor = False
  allowedHypervisors = {'vmware-workstation': 'lib.Hypervisor.VmwareWorkstation'}
  parser = False
  knackConfig = {}


  def __init__(self, boxName):
    self.__loadConfigFile(boxName)   

  def __createVmBasePath(self):
    try:
      os.makedirs(self.guest.getConfig().getVmPath())
    except OSError as exc: # Python >2.5
      if exc.errno == errno.EEXIST and os.path.isdir(self.guest.getConfig().getVmPath()):
        pass
      else: 
        raise

  def __loadConfigFile(self, boxName):
    self.parser = ConfigParser()
    self.parser.load()

    boxYaml = self.parser.getConfigForBox(boxName)
    boxConfig = BoxConfig(boxYaml)

    self.guest = self.__instantiateGuest(boxConfig)
    self.hypervisor = self.__instantiateHypervisor()
    
    self.__createVmBasePath()

  def __instantiateGuest(self, boxConfig):
    # get it dynamicly by ostype in config
    return Debian(boxConfig)


  def __instantiateHypervisor(self):
    # get it dynamicly from allowedHypervisors
    return VmwareWorkstation()


  # accessible knack actions
  #start|stop|restart|ssh|destroy|status
  def start(self):
    self.hypervisor.start(self.guest)

  def stop(self):
    self.hypervisor.stop(self.guest)

  def restart(self):
    self.hypervisor.restart(self.guest)

  def ssh(self):
    # check if box is created, if not throw an error to start it first
    # check if box is registered, if not throw an error to start it first
    # check if box is started, if not throw an error to start it first
    # if yes ssh into it
    print("ssh into box " + self.guest.getConfig().getHostname())	

  def destroy(self):
    self.hypervisor.destroy(self.guest)
    # check if started, if yes stop
    # check if registered, if yes unregister
    # check if created, if yes destroy
    print("destroy box " + self.guest.getConfig().getHostname())

  def status(self):
    status = "Not created"
    if self.hypervisor.isCreated(self.guest):
      status = "Stopped"
    if self.hypervisor.isRunning(self.guest):
      status = "Running but no VMWareTools installed"
    if self.hypervisor.isInstalled(self.guest):
      status = "Running and vmware-tools installed"

    # just print the status
    print(self.guest.getConfig().getHostname() + " is in state: " + status)

  def installVmWareTools(self):
    self.hypervisor.installVmWareTools(self.guest)

