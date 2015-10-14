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

  def createConfigFile(self, guest):
    self.vmx.write(guest)

  def createDisk(self, guest):
    self.disk.create(guest)

  def isRegistered(self, guest):
    raise NotImplementedError("Not able to fetch registered vm's in vmware-workstation")

  def register(self, guest):
    raise NotImplementedError("Not able to register a vm in vmware-workstation")

  def isRunning(self, guest):
    command = [
      "vmrun",
      "list",
      "nogui"
    ]

    processOutput = subprocess.check_output(command)
    if type(processOutput) is bytes:
      processOutputString = processOutput.decode("utf-8")
      runningVms = processOutputString.split("\n")
      return self.vmx.getPath(guest) in runningVms
    return False

  def isCreated(self, guest):
    return os.path.isfile(self.vmx.getPath(guest))

  def isInstalled(self, guest):
    if self.isRunning(guest):
      return self.vmwareTools.hasRealVmwareToolsInstalled(guest)
    return False
  
  def start(self, guest):
    if not self.isRunning(guest):
      self.createConfigFile(guest)
      self.createDisk(guest)
      
      # vmrun start wont register a box and registering a box with vmrun register wont work
      # vmware -x registers and starts a box properly
      command = [
        "vmrun",
        "start",
        self.vmx.getPath(guest),
        "nogui"
      ]

      print(subprocess.check_output(command))
    else:
      print('vm already started')

  def stop(self, guest):
    if self.isRunning(guest):
      command = [
        "vmrun",
        "stop",
        self.vmx.getPath(guest),
        "hard"
      ]

      print(subprocess.check_output(command))
    else:
      print('vm not running, so nothing to stop')

  def restart(self, guest):
    if self.isRunning(guest):
      self.stop(guest)

    self.start(guest)

  def destroy(self, guest):
    if self.isCreated(guest):
      if self.isRunning(guest):
        self.stop(guest)

        command = [
          "vmrun",
          "deleteVM",
          self.vmx.getPath(guest),
          "nogui"
        ]

        print(subprocess.check_output(command))
    else:
      print('vm not created, so nothing to destroy')

  def installVmWareTools(self, guest):
    self.vmwareTools.installVmWareTools(guest)