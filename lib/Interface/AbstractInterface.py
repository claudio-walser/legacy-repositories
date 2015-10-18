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

  """
  askFor: Ask for user input

    @arg msg:str        Question to ask
    @arg optoions:list  List with possible options
    @arg default:str    Default string 
    @return bool        Returns True
  """ 
  def askFor(self, prompt: str, options: list = False, default: str = False):
    raise Exception("Not implemented in abstract class lib.Interface.AbstractInterface.AbstractInterface")