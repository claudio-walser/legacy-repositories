#!/usr/bin/env python3

class DefaultHypervisor(object):

  # abstract methods to be overwritten in concrete hypervisors
  def start(self, guest):
    raise NotImplementedError( "Should have implemented this" )

  def stop(self, guest):
    raise NotImplementedError( "Should have implemented this" )

  def restart(self, guest):
    raise NotImplementedError( "Should have implemented this" )

  def destroy(self, guest):
    raise NotImplementedError( "Should have implemented this" )

  def isCreated(self, guest):
   raise NotImplementedError( "Should have implemented this" )

  def isRunning(self, guest):
    raise NotImplementedError( "Should have implemented this" )

  def isInstalled(self, guest):
    raise NotImplementedError( "Should have implemented this" )
