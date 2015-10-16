#!/usr/bin/env python3


import sys


"""
Cli interface class, currently just use to mojo-fy the output.
"""
class Cli(object):
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
    @arg code:int   (Non-Zero)Exit Code - default to 1
    @void
  """ 
  def error(self, msg: str, code: int = 1):
    # some cli colors
    print(self.FAIL + "Error: " + self.ENDC)
    print(msg)    
       
    sys.exit(code)

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
