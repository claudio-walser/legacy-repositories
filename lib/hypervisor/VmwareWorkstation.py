#!/usr/bin/env python3

import os
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

  def isCreated(self, box):
    hasConfig = os.path.isfile(self.__getConfigPath(box))
    hasDisk = os.path.isfile(self.__getDiskPath(box))

    return hasConfig and hasDisk

  def create(self, box):
    if not self.isCreated(box):
      print('config not found: ' + self.__getConfigPath(box))
      print('disk not found: ' + self.__getDiskPath(box))
      print('creates box')
    else:
      print('already created')
    # /usr/bin/vmware-vdiskmanager
    # write configs into .vmx file

  def isRegistered(self, box):
    print('checks if box is registered in vmwware workstation')
    # not quite sure yet

  def register(self, box):
    print('register box in vmware workstation')

  def isStarted(self, box):
    print('check if box is running')

  def start(self, box):
    print('start box')

  def stop(self, box):
    print('stop box')

  def restart(self, box):
    if self.isStarted():
      self.stop()

    self.start()



  def __getConfigPath(self, box):
    # expand ~ with current user directory
    return os.path.expanduser(box.getVmPath() + box.getFQDN() + ".vmx")

  def __getDiskPath(self, box):
    # expand ~ with current user directory
    return os.path.expanduser(box.getVmPath() + box.getFQDN() + ".vmdk")


  def ssh(self):
    print('ssh')
    # not quite sure yet

  def createDisk(self):
    print('createDisk')
    #/usr/bin/vmware-vdiskmanager start $VM_PATH/$FQDN.vmx

  def register(self):
    print('register')
    #/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;