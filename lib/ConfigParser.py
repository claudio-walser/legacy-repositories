#!/usr/bin/env python3

import os
import yaml
import re

class ConfigParser:

  yaml = {}

  def load(self):
    # raise exception if no .Knackfile in current working dir
    if not os.path.isfile("./.Knackfile"):
      raise Exception('No .Knackfile found in ' + os.getcwd())

    # open and load .Knackfile
    with open("./.Knackfile", 'r') as stream:
      self.yaml = yaml.safe_load(stream)
      stream.close()

  def getConfigForBox(self, box):
    # get default vm config
    boxConfig = self.yaml["vm-defaults"]
    # extract shared_folders, because lists wont merge
    defaultSharedFolders = boxConfig["shared_folders"]

    #raise exception if no config found for this box
    if not box in self.yaml["boxes"]:
      raise Exception('ConfigException', 'No box found with name ' + box)
    
    # apply box config onto default config
    boxConfig.update(self.yaml["boxes"][box])
    # merge in default shared folders
    for sharedFolder in defaultSharedFolders:
      boxConfig["shared_folders"].append(sharedFolder)
    # replace variables placed in config
    boxConfig = self.applyVariables(boxConfig)

    return boxConfig

  def applyVariables(self, boxConfig):
    # loop through box config
    i = 0;
    for key in boxConfig:
      # if its a list take alphanumeric keys
      if type(boxConfig) is list:
        key = i
      # replace placeholders with real values for strings
      if type(boxConfig[key]) is str:
        boxConfig[key] = self.applyVariablesToString(boxConfig[key])
      # call recursive for dicts
      elif type(boxConfig[key]) is dict:
        boxConfig[key] = self.applyVariables(boxConfig[key])
      # todo: fix lists
      elif type(boxConfig[key]) is list:
        boxConfig[key] = self.applyVariables(boxConfig[key])
      i += 1

    return boxConfig

  def applyVariablesToString(self, string):
    # regex for finding placeholders
    matches = re.match(".*(<% ([A-Za-z\.\-_]+) %>).*", string)
    if matches:
      # get match groups
      toReplace = matches.group(1)
      toSplit = matches.group(2)
      
      # split placeholder and search in config for its value
      keys = toSplit.split(".")
      config = self.yaml
      foundAll = False
      for key in keys:
        if key in config:
          foundAll = True
          config = config[key]
        else:
          foundAll = False

      # if the whole namespace found, replace the real value
      if foundAll:
        string = string.replace(toReplace, config)

    return string