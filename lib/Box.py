#!/usr/bin/env python3

import os

class Box(object):
  
  config = {}

  def __init__(self, config):
    self.config = config
  
  def getVmPath(self):
    # todo: check if there is a trailing slash on basePath
    return os.path.expanduser(self.getBasePath() + "/" + self.getDomain() + "/" + self.getEnvironment() + "/" + self.getHostname() + "/")

  def getGuestOs(self):
    return self.config['guest_os']

  def getUser(self):
    return self.config['user']

  def getPass(self):
    return str(self.config['pass'])

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
      raise Exception('ParameterException', 'You requesting an interface i dont have in cofig: ' + eth)

    return self.config['network'][eth]