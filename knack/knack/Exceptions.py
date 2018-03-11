#!/usr/bin/env python3

"""
Exceptions for Knack
"""
class KnackException(Exception):
  pass


"""
Exceptions for Knackfile
"""
class KnackfileAlreadyFoundException(Exception):
  pass

class KnackfileNotFoundException(Exception):
  pass

class KnackfileBoxNotFoundException(Exception):
  pass

class KnackfileReusableConfigException(Exception):
  pass


"""
Guest Exceptions
"""
class GuestNoVmwareToolsException(Exception):
  pass


"""
SSH Provisioner Exceptions
"""
class SshNoPublicKeyException(Exception):
  pass