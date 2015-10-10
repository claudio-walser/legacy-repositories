#!/usr/bin/env python3

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

  def isCreated(self):
    print(os.path.isfile("./.Knackfile"))
    print(self.__getVmxPath())
    print(self.__getDiskPath())

    print('check if box is physicly created on disk')

  def create(self):
    print('creates box')
    # /usr/bin/vmware-vdiskmanager
    # write configs into .vmx file

  def isRegistered(self):
    print('checks if box is registered in vmwware workstation')
    # not quite sure yet

  def register(self):
    print('register box in vmware workstation')

  def isStarted(self):
    print('check if box is running')

  def start(self):
    print('start box')

  def stop(self):
    print('stop box')

  def restart(self):
    if self.isStarted():
      self.stop()

    self.start()



  def __getVmxPath(self):
    return 'hui buh'

  def __getDiskPath(self):
    return 'hui hui buh'




  def ssh(self):
    print('ssh')
    # not quite sure yet

  def createDisk(self):
    print('createDisk')
    #/usr/bin/vmware-vdiskmanager start $VM_PATH/$FQDN.vmx

  def register(self):
    print('register')
    #/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;