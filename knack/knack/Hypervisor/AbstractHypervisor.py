#!/usr/bin/env python3

"""
Abstract base Hypervisor
"""
class AbstractHypervisor(object):

  def isCreated(self):
    raise Exception("Not implemented")

  def isRunning(self):
    raise Exception("Not implemented")

  def isInstalled(self):
    raise Exception("Not implemented")