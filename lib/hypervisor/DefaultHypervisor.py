#!/usr/bin/env python3
import os

class DefaultHypervisor(object):

  box = False

  def setBox(self, box):
    self.box = box


  # abstract methods to be overwritten in concrete hypervisors
  def isCreated(self):
    raise NotImplementedError( "Should have implemented this" )

  def create(self):
   raise NotImplementedError( "Should have implemented this" )

  def isRegistered(self):
    raise NotImplementedError( "Should have implemented this" )

  def register(self):
    raise NotImplementedError( "Should have implemented this" )

  def isStarted(self):
    raise NotImplementedError( "Should have implemented this" )

  def start(self):
    raise NotImplementedError( "Should have implemented this" )

  def stop(self):
    raise NotImplementedError( "Should have implemented this" )