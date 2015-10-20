#!/usr/bin/env python3

from lib.Guest.Debian import Debian

"""
Guest Factory, creates the right guest object from
given configs.
"""
class GuestFactory(object):


  """
  create: Creates a guest object from given config

    @static
    @void
  """ 
  def create(boxConfig):
    if not "guest_os" in boxConfig:
      raise Exception("You have to pass guest_os in boxConfig")

    if boxConfig["guest_os"] == "debian8-64" or boxConfig["guest_os"] == "debian7-64":
      return Debian(boxConfig)

    # raise an exception?
    return False
