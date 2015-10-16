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
def getActions(prefix, parsed_args, **kwargs):
  return (v for v in knack.getActions() if v.startswith(prefix))
def getBoxes(prefix, parsed_args, **kwargs):
  return (v for v in knack.getBoxList("*") if v.startswith(prefix))

# create parser in order to autocomplete
parser = argparse.ArgumentParser()
parser.add_argument("action", help="Action to exectue.", type=str).completer = getActions
parser.add_argument("box", default="*", help="Box to exectue action on", type=str).completer = getBoxes
argcomplete.autocomplete(parser)


"""
This is the main cli script for Knack.
Link this in your local binary directory like this:
  sudo ln -s `pwd`/knack.py /usr/local/bin/knack

Its basicly a dispatcher using argparse.
"""
def main():
  # hack to make last argument optional
  if len(sys.argv) == 2:
    sys.argv.append('*')

  if len(sys.argv) != 3:
    raise Exception('ArgumentException', 'You have to pass two arguments in maximum, action and box')

  arguments = parser.parse_args()
  dispatch(arguments.action, arguments.box)


"""
dispatch: Calls desired action with box in Knack
  @arg action: Action to call
  @arg box: Box to perform action with
  @void
"""
def dispatch(action, box):
  knack = Knack()
  methodToCall = getattr(knack, action)
  result = methodToCall(box)


"""
Handle main loop
"""
if __name__ == '__main__':
  main()