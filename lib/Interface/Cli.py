#!/usr/bin/env python3


import sys

from lib.Interface.AbstractInterface import AbstractInterface

"""
Cli interface class, currently just used to mojo-fy the output with some colors.
"""
class Cli(AbstractInterface):
  """
  Different colors for cli
  """
  # style
  HEADER = '\033[95m'
  BOLD = '\033[1m'
  UNDERLINE = '\033[4m'
  
  # good
  OKBLUE = '\033[94m'
  OKGREEN = '\033[92m'
  
  # not so good
  WARNING = '\033[93m'
  FAIL = '\033[91m'
  
  # closing character
  ENDC = '\033[0m'
  

  """
  error: Displays the error message on command line

    @arg msg:str    Message to display before exit
    @return bool    Returns True
  """ 
  def error(self, msg: str):
    # some cli colors
    print(self.FAIL + "Error: " + self.ENDC)
    print(msg)

    return True

  """
  warning: Displays a message as header

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def warning(self, msg: str):
    # some cli colors
    print(self.WARNING + "Error: " + self.ENDC)
    print(msg)  

    return True

  """
  header: Displays a message as header

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def header(self, msg: str):
    # some cli colors
    print(self.HEADER + msg + self.ENDC)

    return True

  """
  info: Displays a message as info

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def info(self, msg: str):
    # some cli colors
    print(self.OKBLUE + msg + self.ENDC)

    return True

  """
  ok: Displays a message as ok

    @arg msg:str    Message to display
    @return bool    Returns True
  """ 
  def ok(self, msg: str):
    # some cli colors
    print(self.OKGREEN + msg + self.ENDC)

    return True

  """
  askFor: Ask for user input, reask if invalid answer given.

    @arg msg:str        Question to ask
    @arg optoions:list  List with possible options
    @arg default:str    Default string 
    @return bool        Returns True
  """ 
  def askFor(self, prompt: str, options: list = False, default: str = False):
    self.info(prompt + ":")
    if type(options) == list:
      print(self.BOLD + "Possibilities: " + self.ENDC + "[" + ", ".join(options) +  "]")
     
    if default != False:
      print(self.BOLD + "Default: " + self.ENDC + default)

    value = input("")

    if value == "" and default != False:
      value = default

    if type(options) == list and value not in options:
      self.error("Value <" + value + "> not allowed! Choose one of " + ", ".join(options))
      return self.askFor(prompt, options, default)
    return value