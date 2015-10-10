#!/usr/bin/env python3

import os
import subprocess
from string import Template
from lib.hypervisor.DefaultHypervisor import DefaultHypervisor

class VmwareWorkstation(DefaultHypervisor):



  # abstract methods to be overwritten in concrete hypervisors
  def hasConfigFile(self, box):
    return os.path.isfile(self.__getConfigPath(box))

  def createConfigFile(self, box):
    if not self.hasConfigFile(box):
      # need to beautify this
      s = Template("""#!/usr/bin/vmware
.encoding = "UTF-8"

msg.autoAnswer = "true"
guestOS = "debian7-64"
config.version = "8"
virtualHW.version = "9"
machine.id = "$fqdn"

numvcpus = "$cpu"
memsize = "$memory"
displayName = "$fqdn"
extendedConfigFile = "$extendedConfigFile"

scsi0.present = "true"
scsi0.sharedBus = "none"
scsi0.virtualDev = "lsilogic"
scsi0:0.present = "true"
scsi0:0.fileName = "$diskFile"
scsi0:0.deviceType = "disk"

ide0:0.present = "true"
ide0:0.deviceType = "cdrom-image"
ide0:0.startConnected = "true"
ide0:0.autodetect = "true"
ide0:0.fileName = "$installMedium"

# shared folders
sharedFolder.maxNum = "$numSharedFolders"
isolation.tools.hgfs.disable = "false"
"""
      )
  
      substitutedConfig = s.substitute(
        fqdn =box.getFQDN(),
        cpu = box.getHardwareCpu(),
        memory = box.getHardwareMemory(),
        extendedConfigFile = self.__getConfigPath(box) + "f",
        diskFile = self.__getDiskPath(box),
        installMedium = box.getInstallMedium(),
        numSharedFolders = len(box.getSharedFolders())
      )

      # find out how to do this in string.Template
      # append shared folders
      i = 0
      for sharedFolder in box.getSharedFolders():
        if sharedFolder[:1] == '.':
          sharedFolder = os.getcwd() + sharedFolder[1:]
          guestName = sharedFolder.split("/").pop()
        sharedFolderTemplate = Template("""
sharedFolder$i.present = "true"
sharedFolder$i.enabled = "true"
sharedFolder$i.readAccess = "true"
sharedFolder$i.writeAccess = "true"
sharedFolder$i.hostPath = "$sharedFolder"
sharedFolder$i.guestName = "$guestName"
sharedFolder$i.expiration = "never"
"""
        )

        # replace leading dot with current working dir
        sharedFolderConfig = sharedFolderTemplate.substitute(
          i = i,
          sharedFolder = sharedFolder,
          guestName = guestName
        )
        i += 1
        substitutedConfig += sharedFolderConfig
        


      #substitutedConfig += "\n# network interfaces"
      i = 0
      for interface in box.getNetworkInterfaces():
        
        networkTemplate = Template("""
ethernet$i.present = "true"
ethernet$i.connectionType = "bridged"
ethernet$i.generatedAddressOffset = "$offset"
ethernet$i.wakeOnPcktRcv = "false"
ethernet$i.addressType = "generated"
ethernet$i.pciSlotNumber = "3$i"
"""
        )

        # replace leading dot with current working dir
        networkConfig = networkTemplate.substitute(
          i = i,
          offset = i * 10
        )
        i += 1
        substitutedConfig += networkConfig

      with open(self.__getConfigPath(box), "w") as configFile:
        configFile.write("%s" % substitutedConfig)
      
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
    raise NotImplementedError("Not able to register a vm in vmware-workstation")

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
