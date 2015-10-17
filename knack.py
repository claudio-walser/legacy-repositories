#!/usr/bin/env python3
# PYTHON_ARGCOMPLETE_OK

import sys
import argcomplete
import argparse

from lib.Knack import Knack


"""
This is the main cli script for Knack.
Link this in your local binary directory like this:
  sudo ln -s `pwd`/knack.py /usr/local/bin/knack

Its basicly a dispatcher using argparse.
"""

"""
Knack instance
"""
knack = Knack()


"""
Argparser and Argcompletion.
"""
# hack to make last argument optional
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
argcomplete.autocomplete(parser)

"""
dispatch: Calls desired action with box in Knack

  @arg action: Action to call
  @arg box: Box to perform action with
  @void
"""
def main(action: str, box: str):
  # abort if not initialize and still no config
  if knack.knackfile.loaded == False and action != "init":
    sys.exit(1)

  methodToCall = getattr(knack, action)
  result = methodToCall(box)


"""
Handle main loop
"""
if __name__ == '__main__':
  arguments = parser.parse_args()
  main(arguments.action, arguments.box)