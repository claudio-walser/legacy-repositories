#!/usr/bin/env python3


import sys
import argparse

from lib.Knack import Knack


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

  parser = argparse.ArgumentParser()
  parser.add_argument("action", help="Action to exectue. Possible actions are: status|start|stop|restart|ssh|provision|destroy", type=str)
  parser.add_argument("box", default="*", help="Box to exectue action on", type=str)
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