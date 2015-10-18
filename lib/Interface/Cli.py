#!/usr/bin/env python3

import os
import re
import readline

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
    @arg optoions:mixed List with possible options or string "os.directory" for os directory tab completion
    @arg default:str    Default string 
    @return bool        Returns True
  """ 
  def askFor(self, prompt: str, options = False, default: str = False):
    self.info(prompt)

    completer = InputCompleter()
    readline.set_completer_delims(' \t\n;')
    readline.parse_and_bind("tab: complete")

    # given options completer
    if type(options) == list:
      print(self.BOLD + "Possibilities: " + self.ENDC + "[" + ", ".join(options) +  "]")

      completer.setPossibilities(options)
      readline.set_completer(completer.completeOptions)

    # directory completer
    if type(options) == str and options == "os.directory":
      # just here to clarify, do nothing is perfect for /folder/completion if readline is parsed and bound
      pass

    # if no options set, use an empty completer as default
    if options == False:
      readline.set_completer(completer.completeNothing)
     
    if default != False:
      print(self.BOLD + "Default: " + self.ENDC + default)
      

    value = input("")
    # reset all completers first
    readline.set_completer()

    if type(value) == str:
      value = value.strip()

    if value == "" and default != False:
      value = default

    if type(options) == list and value not in options:
      self.error("Value <" + value + "> not allowed! Choose one of " + ", ".join(options))
      return self.askFor(prompt, options, default)
    return value











class InputCompleter(object):

    possibilities = []
    re = re.compile('.*\s+$', re.M)
    
    def setPossibilities(self, possibilities: list):
      self.possibilities = possibilities

    def completeNothing(self, text, state):
      return False

    def completeOptions(self, text, state):
        # need to simplify this much more,l sure there is a lot to much
        buffer = readline.get_line_buffer()
        line = readline.get_line_buffer().split()
        # show all commands
        if not line:
            return [c + ' ' for c in self.possibilities][state]

        # account for last argument ending in a space
        if self.re.match(buffer):
            line.append('')
        # resolve command to the implementation function
        cmd = line[0].strip()
        if cmd in self.possibilities:
            impl = getattr(self, 'complete_%s' % cmd)
            args = line[1:]
            if args:
                return (impl(args) + [None])[state]
            return [cmd + ' '][state]
        results = [c + ' ' for c in self.possibilities if c.startswith(cmd)] + [None]
        return results[state]

