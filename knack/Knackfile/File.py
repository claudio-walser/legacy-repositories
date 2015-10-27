#!/usr/bin/env python3


import os
import yaml

from knack.Knackfile.Parser import Parser

from knack.Exceptions import KnackfileNotFoundException
from knack.Exceptions import KnackfileBoxNotFoundException
from knack.Exceptions import KnackfileReusableConfigException
from knack.Exceptions import KnackfileAlreadyFoundException


"""
This is the Knackfile implementation. This class does load
a .Knackfile in the current working directory, parses its content into a list
and applies some variable replacement for some flexibility
"""
class File:

  """
  loaded: bool Indicates if config has been loaded successfully
  """
  loaded = False

  """
  parser: knack.Knackfile.Parser    Helper for some yaml parsing stuff
  """
  parser = Parser()

  """
  write: Writes a new .Knackfile in current working directory by given config.

    @arg configToWrite:dict   Config to write into .Knackfile
    @raises KnackfileAlreadyFoundException    .Knackfile already found in cwd
    @return bool              True or False, whether the file has been written or not
  """
  def write(self, configToWrite):
    if os.path.isfile("./.Knackfile"):
      raise KnackfileAlreadyFoundException('.Knackfile already found in ' + os.getcwd())


    #split config for odering
    hypervisorConfig = {
      'hypervisor': configToWrite["hypervisor"]
    }
    vmDefaultConfig = {
      'vm-defaults': configToWrite["vm-defaults"]
    }
    boxesConfig = {
      'boxes': configToWrite["boxes"]
    }

    with open("./.Knackfile", "w") as outfile:
      outfile.write(yaml.dump(hypervisorConfig, default_flow_style=False))
      outfile.write("\n")
      outfile.write(yaml.dump(vmDefaultConfig, default_flow_style=False))
      outfile.write("\n")
      outfile.write(yaml.dump(boxesConfig, default_flow_style=False))
      return True

    return False

  """
  load: Tries to load .Knackfile in cwd

    @raises KnackfileNotFoundException    No .Knackfile found in cwd
    @return bool
  """
  def load(self):
    # raise exception if no .Knackfile in current working dir
    if not os.path.isfile("./.Knackfile"):
      raise KnackfileNotFoundException('No .Knackfile found in ' + os.getcwd())

    self.loaded = self.parser.load("./.Knackfile")
    
    return self.loaded

  """
  hasBox: Checks if given box name is present in config

    @arg box:str             Box Name you like to check
    @return bool
  """
  def hasBox(self, box: str):
    if self.loaded == False:
      return False

    return box in self.parser.getConfigByNamespace("boxes")

  """
  getAllBoxNames: Checks if given box name is present in config

    @return list             Returns a list of all box names
  """
  def getAllBoxNames(self):
    if self.loaded == False:
      return []

    return self.parser.getConfigByNamespace("boxes").keys()


  """
  getConfigForBox: Get you the config of a desired box with the applied defaults

    @arg box:str                            Box Name you like to get the config of
    @raises KnackfileBoxNotFoundException   Box not found in current .Knackfile
    @return dict                            Returns the deep merged dict
  """
  def getConfigForBox(self, box: str):
    if self.loaded == False:
      return {}

    # get default vm config
    defaultConfig = self.parser.getConfigByNamespace("vm-defaults")
    if not self.hasBox(box):
      raise KnackfileBoxNotFoundException("Box not found in current .Knackfile")

    boxConfig = self.parser.deepMerge(defaultConfig, self.parser.getConfigByNamespace("boxes.%s" % box))
    boxConfig = self.parser.applyVariables(boxConfig)

    return boxConfig

