#!/usr/bin/env python3

import importlib
from lib.ConfigParser import ConfigParser
from lib.hypervisor.VmwareWorkstation import VmwareWorkstation
from lib.Box import Box
from pprint import pprint

class Knack(object):
  
  box = '*'
  allowedHypervisors = {'vmware-workstation': 'lib.hypervisor.VmwareWorkstation'}
  parser = False
  knackConfig = {}


  def __init__(self, boxName):
   self.loadConfigFile(boxName)   

  def loadConfigFile(self, boxName):
    self.parser = ConfigParser()
    self.parser.load()
    boxConfig = self.parser.getConfigForBox(boxName)

    box = Box(boxConfig)
    hypervisor = self.instantiateHypervisor()
    # so far so good
    print(box.getHostname())
    print(box.getNetwork('eth0'))
    print(box.getNetwork('eth1'))

  def instantiateHypervisor(self):
    return VmwareWorkstation()
    #if not self.parser.getHypervisor() in self.allowedHypervisors:
    #  raise Exception('ConfigException', 'Hypervisor ' + self.parser.getHypervisor() + ' is not available')
    
    #hypervisorClass = self.allowedHypervisors[self.parser.getHypervisor()]
    #module_name, class_name = hypervisorClass.rsplit(".", 1)

    #print(importlib.import_module(module_name))

    #HypervisorClass = getattr(importlib.import_module(module_name), class_name)
    #instance = HypervisorClass()
    #print('dafuuq')
    #pprint(lib.hypervisor.VmwareWorkstation())


  #start|stop|restart|ssh|destroy|status
  def start(self):
    print("Start or even install box " + self.box)

  def stop(self):
    print("stop box " + self.box)

  def restart(self):
    print("restart box " + self.box)

  def ssh(self):
    print("ssh into box " + self.box)	

  def destroy(self):
    print("destroy box " + self.box)

  def status(self):
    print("status of box " + self.box)

