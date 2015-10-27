#!/usr/bin/env python3

"""
Some (hopefully but probably not so) meaningful exception names
"""
class KnackException(Exception):
  pass

class KnackfileAlreadyFoundException(Exception):
  pass

class KnackfileNotFoundException(Exception):
  pass

class KnackfileBoxNotFoundException(Exception):
  pass

class KnackfileReusableConfigException(Exception):
  pass