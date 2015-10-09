#!/usr/bin/env python3

import os
import yaml

class ConfigParser:

  yaml = {}

  def load(self):
    if not os.path.isfile("./.Thingyfile"):
      raise Exception('No .Thingyfile found in ' + os.getcwd())

    with open("./.Thingyfile", 'r') as stream:
      self.yaml = yaml.safe_load(stream)
      stream.close()



  def getConfigForBox(self, box):
    boxConfig = self.yaml["vm-defaults"]
    defaultSharedFolders = boxConfig["shared_folders"]

    if not box in self.yaml["boxes"]:
      raise Exception('ConfigException', 'No box found with name ' + box)
    
    boxConfig.update(self.yaml["boxes"][box])
    
    for sharedFolder in defaultSharedFolders:
      boxConfig["shared_folders"].append(sharedFolder)

    return boxConfig

  def applyVariables(self, boxConfig):

    for config in boxConfig:
      print(type(config))
      print(config)
