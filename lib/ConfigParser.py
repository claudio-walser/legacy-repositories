#!/usr/bin/env python3

import yaml

class ConfigParser:

  def parse():
    with open("example.yaml", 'r') as stream:
      print('hui')
      print(yaml.load(stream))