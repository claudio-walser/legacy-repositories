#!/usr/bin/env python3

from lib.Guest.AbstractGuest import AbstractGuest

"""
Debian Guest
"""
class Debian(AbstractGuest):


  """
  status: Read status of this box
  """ 
  def status(self):
    print(self.getHostname() + "mother fucker")
    return False
