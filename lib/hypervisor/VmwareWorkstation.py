#!/usr/bin/env python3

import os
import subprocess
from lib.hypervisor.DefaultHypervisor import DefaultHypervisor

class VmwareWorkstation(DefaultHypervisor):

  #vmware
  #vmwarectrl
  #vmware-fuseUI
  #vmware-gksu
  #vmware-hostd
  #vmware-installer
  #vmware-license-check.sh
  #vmware-license-enter.sh
  #vmware-modconfig
  #vmware-mount
  #vmware-netcfg
  #vmware-networks
  #vmware-ping
  #vmware-tray
  #vmware-uninstall
  #vmware-unity-helper
  #vmware-usbarbitrator
  #vmware-vdiskmanager
  #vmware-vim-cmd
  #vmware-vprobe
  #vmware-wssc-adminTool

  # abstract methods to be overwritten in concrete hypervisors
  def hasConfigFile(self, box):
    return os.path.isfile(self.__getConfigPath(box))

  def createConfigFile(self, box):
    if not self.hasConfigFile(box):
      print('write vmx Config file')

  def hasDisk(self, box):
    return os.path.isfile(self.__getDiskPath(box))

  def createDisk(self, box):
    if not self.hasDisk(box):
      # /usr/bin/vmware-vdiskmanager -c -t 0 -s $SIZE -a ide $VM_PATH/$FQDN.vmdk;
      command = [
        "vmware-vdiskmanager",
        "-c",
        "-t",
        "0",
        "-s",
        box.getHardwareDisk(),
        "-a",
        "ide",
        self.__getDiskPath(box)
      ]

      processOutput = subprocess.check_output(command)



  def isRegistered(self, box):
    raise NotImplementedError("Not able to fetch registered vm's in vmware-workstation")

  def register(self, box):
    raise NotImplementedError("Not able to register vm in vmware-workstation")

  def isRunning(self, box):
    command = [
      "vmrun",
      "list" 
    ]

    processOutput = subprocess.check_output(command)
    if type(processOutput) is bytes:
      processOutputString = processOutput.decode("utf-8")
      runningVms = processOutputString.split("\n")
      return self.__getConfigPath(box) in runningVms
    return False

  def start(self, box):
    if not self.isRunning(box):
      self.createConfigFile(box)
      self.createDisk(box)
      
      # vmrun start wont register a box and registering a box with vmrun register wont work
      # vmware -x registers and starts a box properly
      command = [
        "vmware",
        "-x",
        self.__getConfigPath(box)
      ]

      processOutput = subprocess.check_output(command)
    else:
      print('vm already started')

  def stop(self, box):
    if self.isRunning(box):
      print('stop vm')
    else:
      print('vm already stopped')

  def restart(self, box):
    if self.isRunning():
      self.stop()

    self.start()


  # private methods
  def __getConfigPath(self, box):
    # expand ~ with current user directory
    return box.getVmPath() + box.getFQDN() + ".vmx"

  def __getDiskPath(self, box):
    # expand ~ with current user directory
    return box.getVmPath() + box.getFQDN() + ".vmdk"
