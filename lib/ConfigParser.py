#!/usr/bin/env python3

import os.path
import yaml

class ConfigParser:

  def parse():
    if not os.path.isfile("./.Thingyfile"):
      raise Exception('No .Thingyfile found in ' + os.getcwd())

    with open("./.Thingyfile", 'r') as stream:
      print(yaml.load(stream))