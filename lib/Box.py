#!/usr/bin/env python3

class Box(object):
  
  config = {}

  def __init__(self, config):
    self.config = config
  
  def getBasePath(self):
    return self.config['base_path']

  def getInstallMedium(self):
    return self.config['install_medium']

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

  def getNetwork(self, eth='eth0'):
    if eth not in self.config['network']:
      raise Exception('ParameterException', 'You requesting an interface i dont have in cofig: ' + eth)

    return self.config['network'][eth]