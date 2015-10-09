#!/usr/bin/env python3

import os
import yaml

class ConfigParser:

  yml = {}

  def load(self):
    if not os.path.isfile("./.Thingyfile"):
      raise Exception('No .Thingyfile found in ' + os.getcwd())

    with open("./.Thingyfile", 'r') as stream:
      self.yaml = yaml.safe_load(stream)
      stream.close()

  def getConfigForBox(self, box):
    config = self.yaml
    
    if not config.has_key(box):
      raise Exception('ConfigException', 'No box found with name ' + box)
    
    print(config[box])
    print('Load config for ' + box)