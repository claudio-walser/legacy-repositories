#!/usr/bin/env python3

import sys
import argparse
from lib.Knack import Knack


def main():
  # hack to make last argument optional
  if len(sys.argv) == 2:
    sys.argv.append('*')

  if len(sys.argv) != 3:
    raise Exception('ArgumentException', 'You have to pass two arguments in maximum, action and box')

  parser = argparse.ArgumentParser()
  parser.add_argument("action", help="Action to exectue. Possible actions are: start|stop|restart|ssh|destroy|status", type=str)
  parser.add_argument("box", default="*", help="Box to exectue action on", type=str)
  arguments = parser.parse_args()
  
  dispatch(arguments.action, arguments.box)

def dispatch(action, box):
  knack = Knack(box)
  methodToCall = getattr(knack, action)
  result = methodToCall()

if __name__ == '__main__':
  main()