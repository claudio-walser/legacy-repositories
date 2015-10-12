#!/usr/bin/env python3

import os
import subprocess
from lib.Hypervisor.DefaultHypervisor import DefaultHypervisor
# import worker classes
from lib.Hypervisor.VmwareWorkstationWorker.Vmx import Vmx
from lib.Hypervisor.VmwareWorkstationWorker.Disk import Disk
from lib.Hypervisor.VmwareWorkstationWorker.VmwareTools import VmwareTools

class VmwareWorkstation(DefaultHypervisor):

  vmx = False
  disk = False
  vmwareTools = False

  def __init__(self):
    self.vmx = Vmx(self)
    self.disk = Disk(self)
    self.vmwareTools = VmwareTools(self)

  def createConfigFile(self, box):
    self.vmx.write(box)

  def createDisk(self, box):
    self.disk.create(box)

  def isRegistered(self, box):
    raise NotImplementedError("Not able to fetch registered vm's in vmware-workstation")

  def register(self, box):
    raise NotImplementedError("Not able to register a vm in vmware-workstation")

  def isRunning(self, box):
    command = [
      "vmrun",
      "list",
      "nogui"
    ]

    processOutput = subprocess.check_output(command)
    if type(processOutput) is bytes:
      processOutputString = processOutput.decode("utf-8")
      runningVms = processOutputString.split("\n")
      return self.vmx.getPath(box) in runningVms
    return False

  def isCreated(self, box):
    return os.path.isfile(self.vmx.getPath(box))

  def isInstalled(self, box):
    if self.isRunning(box):
      return self.vmwareTools.hasRealVmwareToolsInstalled(box)
    return False
  
  def start(self, box):
    if not self.isRunning(box):
      self.createConfigFile(box)
      self.createDisk(box)
      
      # vmrun start wont register a box and registering a box with vmrun register wont work
      # vmware -x registers and starts a box properly
      command = [
        "vmrun",
        "start",
        self.vmx.getPath(box),
        "nogui"
      ]

      print(subprocess.check_output(command))
    else:
      print('vm already started')

  def stop(self, box):
    if self.isRunning(box):
      command = [
        "vmrun",
        "stop",
        self.vmx.getPath(box),
        "hard"
      ]

      print(subprocess.check_output(command))
    else:
      print('vm not running, so nothing to stop')

  def restart(self, box):
    if self.isRunning(box):
      self.stop(box)

    self.start(box)

  def destroy(self, box):
    if self.isCreated(box):
      if self.isRunning(box):
        self.stop(box)

        command = [
          "vmrun",
          "deleteVM",
          self.vmx.getPath(box),
          "nogui"
        ]

        print(subprocess.check_output(command))
    else:
      print('vm not created, so nothing to destroy')

  def installVmWareTools(self, box):
    self.vmwareTools.installVmWareTools(box)