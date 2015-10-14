#!/usr/bin/env python3

class DefaultGuest(object):

  boxConfig = False

  def __init__(self, boxConfig):
    self.boxConfig = boxConfig

  def getConfig(self):
    return self.boxConfig

    
  # abstract methods to be overwritten in concrete guests
  def getCommandBinary(self):
    raise NotImplementedError( "Should have implemented this" )

  def ejectMedia(self, hypervisor):
    raise NotImplementedError( "Should have implemented this" )

  def installVmWareTools(self, hypervisor):
    raise NotImplementedError( "Should have implemented this" )
