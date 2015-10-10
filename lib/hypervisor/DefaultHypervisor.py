#!/usr/bin/env python3

class DefaultHypervisor(object):


  # abstract methods to be overwritten in concrete hypervisors
  def hasConfigFile(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def createConfigFile(self, box):
   raise NotImplementedError( "Should have implemented this" )

  def hasDisk(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def createDisk(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def isRegistered(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def register(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def isRunning(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def start(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def stop(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def restart(self, box):
    raise NotImplementedError( "Should have implemented this" )