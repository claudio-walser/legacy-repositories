#!/usr/bin/env python3

class DefaultHypervisor(object):

  # abstract methods to be overwritten in concrete hypervisors
  def start(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def stop(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def restart(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def destroy(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def isCreated(self, box):
   raise NotImplementedError( "Should have implemented this" )

  def isRunning(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def isInstalled(self, box):
    raise NotImplementedError( "Should have implemented this" )
