#!/usr/bin/env python3


import sys


"""
Abstract interface class
"""
class AbstractInterface(object):

  """
  error: Displays the error message on command line

    @arg msg:str    Message to display before exit
    @return bool    Returns True
  """ 
  def error(self, msg: str):
    print(msg)

    return True

  """
  warning: Displays a message as header

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def warning(self, msg: str):
    print(msg)  

    return True

  """
  header: Displays a message as header

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def header(self, msg: str):
    print(msg)
    
    return True

  """
  info: Displays a message as info

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def info(self, msg: str):
    print(msg)

    return True

  """
  ok: Displays a message as ok

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def ok(self, msg: str):
    print(msg)

    return True
