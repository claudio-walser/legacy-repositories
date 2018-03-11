#!/usr/bin/env python3

import subprocess
import pprint

class VmwareTools(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def has(self, guest):
    if self.hypervisor.isRunning(guest):
      command = [
        "vmrun",
        "checkToolsState",
        self.hypervisor.vmx.getPath(guest)
      ]

      try:
        processOutput = subprocess.check_output(command)
      except:
        return False
        
      if type(processOutput) is bytes:
        processOutputString = processOutput.decode("utf-8")
        toolsState = processOutputString.split("\n")
        return "running" in toolsState
    return False
