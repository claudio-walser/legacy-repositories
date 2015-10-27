#!/usr/bin/env python3

import os

"""
Abstract base Guest
"""
class GuestConfig(object):

  config = {}
  name = ""
  username = "root"
  publicKey = "~/.ssh/id_rsa.pub"

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

  def setName(self, name: str):
    self.name = name

    return True

  def getName(self):
    return self.name

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
    if not "shared_folders" in self.config:
      return []
      
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
