#!/usr/bin/env python3

class VmwareWorkstation(object):

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


  def install(self):
    print('install')
    # /usr/bin/vmware-vdiskmanager
    # write configs into .vmx file

  def ssh(self):
    print('ssh')
    # not quite sure yet

  def isRegistered(self):
    print('isRegistered')
    # not quite sure yet

  def createDisk(self):
    print('createDisk')
    #/usr/bin/vmware-vdiskmanager start $VM_PATH/$FQDN.vmx

  def register(self):
    print('register')
    #/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;