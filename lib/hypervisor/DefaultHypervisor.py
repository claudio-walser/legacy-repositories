#!/usr/bin/env python3

class DefaultHypervisor(object):


  # abstract methods to be overwritten in concrete hypervisors
  def isCreated(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def create(self, box):
   raise NotImplementedError( "Should have implemented this" )

  def isRegistered(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def register(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def isStarted(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def start(self, box):
    raise NotImplementedError( "Should have implemented this" )

  def stop(self, box):
    raise NotImplementedError( "Should have implemented this" )