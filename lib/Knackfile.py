#!/usr/bin/env python3


import os
import yaml
import re

from lib.Exceptions import KnackfileNotFoundException
from lib.Exceptions import KnackfileBoxNotFoundException
from lib.Exceptions import KnackfileReusableConfigException


"""
This is the Knackfile implementation. This class does load
a .Knackfile in the current working directory, parses its content into a list
and applies some variable replacement for some flexibility
"""
class Knackfile:

  """
  yaml: yaml Instance of python3-yaml for easy parsing
  """
  yaml = {}


  """
  load: Tries to load .Knackfile in cwd

    @raises KnackfileNotFoundException    No .Knackfile found in cwd
    @return bool
  """
  def load(self):
    # raise exception if no .Knackfile in current working dir
    if not os.path.isfile("./.Knackfile"):
      raise KnackfileNotFoundException('No .Knackfile found in ' + os.getcwd())

    # open and load .Knackfile
    with open("./.Knackfile", 'r') as stream:
      self.yaml = yaml.safe_load(stream)

    return True


  """
  deepMerge: Does apply the box config onto the default config recursive

    @arg dict1:dict         Default Dictionary
    @arg dict2:dict         Dictionary to be applied recursive
    @return dict            Returns the deep merged dict
  """
  def deepMerge(self, dict1: dict, dict2: dict):
    # append for lists
    if isinstance(dict1, list) and isinstance(dict2, list):
      for element in dict2:
        dict1.append(element)
        return dict1
    # return dict2 value for everything which is not a list or a dict
    if not isinstance(dict1, dict) or not isinstance(dict2, dict):
        return dict2
    # loop through dicts and call recursive
    for k in dict2:
        if k in dict1:
            dict1[k] = self.deepMerge(dict1[k], dict2[k])
        else:
            dict1[k] = dict2[k]
            
    return dict1


  """
  hasBox: Checks if given box name is present in config

    @arg box:str             Box Name you like to check
    @return bool
  """
  def hasBox(self, box: str):
    return box in self.yaml["boxes"]

  """
  getAllBoxNames: Checks if given box name is present in config

    @return list             Returns a list of all box names
  """
  def getAllBoxNames(self):
    return self.yaml["boxes"].keys()


  """
  getConfigForBox: Get you the config of a desired box with the applied defaults

    @arg box:str                            Box Name you like to get the config of
    @raises KnackfileBoxNotFoundException   Box not found in current .Knackfile
    @return dict                            Returns the deep merged dict
  """
  def getConfigForBox(self, box: str):
    # get default vm config
    defaultConfig = self.yaml["vm-defaults"]
    if not self.hasBox(box):
      raise KnackfileBoxNotFoundException("Box not found in current .Knackfile")

    boxConfig = self.deepMerge(defaultConfig, self.yaml["boxes"][box])
    boxConfig = self.applyVariables(boxConfig)
    return boxConfig

  """
  applyVariables: Search recursive through dict or lists for placeholders,
                  and replace them with desired value.
  
    @arg boxConfig:mixed     Box Name you like to get the config of
    @return mixed            Returns the dict|list with replaced values
  """
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

  """
  applyVariablesToString: Does the real replace job on a string.
                          Searches for placeholders and makes a lookup
                          in current config for the found namespace.

    @arg string:str                           String you want to replace a placeholder within
    @raises KnackfileReusableConfigException  Raises an exception if your replacement still is a list|dict
    @return str                               Returns sanitized string
  """
  def applyVariablesToString(self, string: str):
    # regex for finding placeholders
    matches = re.match(".*(<% ([A-Za-z\.\-_]+) %>).*", string)
    if matches:
      # get match groups
      toReplace = matches.group(1)
      toSplit = matches.group(2)
      config = self.getConfigByNamespace(toSplit)

      # if the whole namespace found, replace the real value
      if config:
        if not type(config) is str:
          raise KnackfileReusableConfigException('ConfigException', 'You are trying to reuse a list in config, which is not supported')
        string = string.replace(toReplace, config)

    return string

  """
  getConfigByNamespace: Gets a value by namespace <name.space.value>.

    @arg namespace:str         Namespace to fetch
    @return str                Returns the value if found or False
  """
  def getConfigByNamespace(self, namespace: str):
    keys = namespace.split(".")
    returnValue = False
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
      returnValue = config

    return returnValue
