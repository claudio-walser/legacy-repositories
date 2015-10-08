#!/usr/bin/env python3

import sys
import argparse
from lib.Thingy import Thingy


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
  thingy = Thingy()
  methodToCall = getattr(thingy, action)
  result = methodToCall(box)

if __name__ == '__main__':
  main()