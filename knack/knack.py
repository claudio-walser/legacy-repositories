#!/usr/bin/env python3
# PYTHON_ARGCOMPLETE_OK

import sys
import argcomplete
import argparse

from knack.Knack import Knack
from knack.Interface.Cli import Cli

"""
This is the main cli script for Knack.
Link this in your local binary directory like this:
  sudo ln -s `pwd`/knack.py /usr/local/bin/knack

Its basicly a dispatcher using argparse.
"""

"""
Knack instance
"""
interface = Cli()
knack = Knack(interface)


"""
Argparser and Argcompletion.
"""
# hack to make "box" argument optional
if len(sys.argv) == 2:
  sys.argv.append('*')

"""
Completer for boxes in an own function cause i dont want to limit the options by setting choices=().
Even if its so awesome to see all possible boxes in --help Description :)
Have to see, if i can tweak choices with an empty value, i am good to reimplement it back ;)
"""
def getBoxes(prefix, parsed_args, **kwargs):
  return (v for v in knack.getBoxList("*") if v.startswith(prefix))

# create parser in order to autocomplete
parser = argparse.ArgumentParser()
parser.add_argument("action", help="Action to execute.", type=str, choices=knack.getActions())
parser.add_argument("box", default="*", help="Box to execute action on", type=str).completer = getBoxes
parser.add_argument("command", nargs='?', default="", help="SSH Command to execute on box. Optional and only meaningful with knack ssh <box>", type=str)
argcomplete.autocomplete(parser)

"""
dispatch: Calls desired action with box in Knack

  @arg action: Action to call
  @arg box: Box to perform action with
  @void
"""
def main(action: str, box: str, command: str):
  # abort if not initialize and still no config
  if not knack.knackfile.loaded and not action == "init":
    interface.error("No .Knackfile exists. Aborting!")
    sys.exit(1)

  # on the other hand if you like to create one and it already exists
  if knack.knackfile.loaded and action == "init":
    interface.error(".Knackfile already exists. Aborting!")
    sys.exit(1)


  try:
    methodToCall = getattr(knack, action)  
  except:
    interface.error("Action %s does not exists, see knack --help for more information." % action)
    sys.exit(1)
  if action == "ssh":
    result = methodToCall(box, command)
  else:
    result = methodToCall(box)
  sys.exit(0)


"""
Handle main loop
"""
if __name__ == '__main__':
  arguments = parser.parse_args()
  main(arguments.action, arguments.box, arguments.command)