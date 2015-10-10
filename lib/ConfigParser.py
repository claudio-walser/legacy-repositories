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

  def deepMerge(dict1, dict2):
    if isinstance(dict1, list) and isinstance(dict2, list):
      for element in dict2:
        dict1.append(element)
        return dict1
    if not isinstance(dict1, dict) or not isinstance(dict2, dict):
        return dict2
    for k in dict2:
        if k in dict1:
            dict1[k] = ConfigParser.deepMerge(dict1[k], dict2[k])
        else:
            dict1[k] = dict2[k]
    return dict1

  def getConfigForBox(self, box):
    # get default vm config
    defaultConfig = self.yaml["vm-defaults"]
    boxConfig = ConfigParser.deepMerge(defaultConfig, self.yaml["boxes"][box])
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