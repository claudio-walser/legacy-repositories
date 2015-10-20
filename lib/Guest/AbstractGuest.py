#!/usr/bin/env python3

import os

from lib.Interface.AbstractInterface import AbstractInterface
from lib.Hypervisor.AbstractHypervisor import AbstractHypervisor

"""
Abstract base Guest
"""
class AbstractGuest(object):

  config = {}
  interface = False
  hypervisor = False

  """
  Constructor: Store config in a class property
  """ 
  def __init__(self, boxConfig):
    # check some mandatory values here
    try:
      self.checkConfig(boxConfig)
      self.config = boxConfig
    except:
      raise

  def setInterface(self, interface: AbstractInterface):
    self.interface = interface
    return True

  def setHypervisor(self, hypervisor: AbstractHypervisor):
    self.hypervisor = hypervisor
    return True

  def createVmBasePath(self):
    try:
      os.makedirs(self.getVmPath())
    except OSError as exc: # Python >2.5
      if exc.errno == errno.EEXIST and os.path.isdir(self.getVmPath()):
        pass
      else: 
        raise

  def checkConfig(self, boxConfig):
    if not "guest_os" in boxConfig:
      raise Exception("Mandatory entry 'guest_os' not found in config")

    if not "base_path" in boxConfig:
      raise Exception("Mandatory entry 'base_path' not found in config")

    if not "install_medium" in boxConfig:
      raise Exception("Mandatory entry 'install_medium' not found in config")

    if not "hostname" in boxConfig:
      raise Exception("Mandatory entry 'hostname' not found in config")

    if not "domain" in boxConfig:
      raise Exception("Mandatory entry 'domain' not found in config")

    if not "environment" in boxConfig:
      raise Exception("Mandatory entry 'environment' not found in config")

    if not "hardware" in boxConfig:
      raise Exception("Mandatory entry 'hardware' not found in config")

    if not "cpu" in boxConfig["hardware"]:
      raise Exception("Mandatory entry 'hardware.cpu' not found in config")

    if not "disk" in boxConfig["hardware"]:
      raise Exception("Mandatory entry 'hardware.disk' not found in config")
   
    if not "memory" in boxConfig["hardware"]:
      raise Exception("Mandatory entry 'hardware.memory' not found in config")

    if not "network" in boxConfig:
      raise Exception("Mandatory entry 'network' not found in config")

    if not "eth0" in boxConfig["network"]:
      raise Exception("Mandatory entry 'network.eth0' not found in config. You will need one interface at least.")

    return True

  
  def getVmPath(self):
    # todo: check if there is a trailing slash on basePath
    return os.path.expanduser(self.getBasePath() + "/" + self.getDomain() + "/" + self.getEnvironment() + "/" + self.getHostname() + "/")

  def getGuestOs(self):
    return self.config['guest_os']

  def getFullDomain(self):
    return self.getEnvironment() + "." + self.getDomain()

  def getFQDN(self):
    return self.getHostname() + "." + self.getFullDomain();

  def getBasePath(self):
    return self.config['base_path']

  def getInstallMedium(self):
    return os.path.expanduser(self.config['install_medium'])

  def getHostname(self):
    return self.config['hostname']

  def getDomain(self):
    return self.config['domain']

  def getEnvironment(self):
    return self.config['environment']

  def getSharedFolders(self):
    return self.config['shared_folders']

  def getHardwareCpu(self):
    return self.config['hardware']['cpu']

  def getHardwareDisk(self):
    return self.config['hardware']['disk']

  def getHardwareMemory(self):
    return self.config['hardware']['memory']

  def getNetworkInterfaces(self):
    return self.config['network']

  def getNetwork(self, eth='eth0'):
    if eth not in self.config['network']:
      raise Exception('ParameterException', 'You requesting an interface which is not defined in your config: ' + eth)

    return self.config['network'][eth]




  """
  Show box status

    @void
  """ 
  def status(self):
    raise Exception("Not implemented")
 
  """
  Start box

    @void
  """ 
  def start(self):
    raise Exception("Not implemented") 

  """
  Stop box

    @void
  """ 
  def stop(self):
    raise Exception("Not implemented")

  """
  Restart box

    @void
  """ 
  def restart(self):
    raise Exception("Not implemented")

  """
  Ssh into box

    @void
  """ 
  def ssh(self):
    raise Exception("Not implemented")

  """
  Provision box

    @void
  """ 
  def provision(self):
    raise Exception("Not implemented")

  """
  Destroy box

    @void
  """ 
  def destroy(self):
    raise Exception("Not implemented")

