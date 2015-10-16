#!/usr/bin/env python3

"""
Some (hopefully) meaningful exception names
"""
class KnackException(Exception):
  pass

class KnackfileNotFoundException(Exception):
  pass

class KnackfileBoxNotFoundException(Exception):
  pass

class KnackfileReusableConfigException(Exception):
  pass