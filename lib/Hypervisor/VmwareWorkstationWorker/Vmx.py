
import os
from string import Template

class Vmx(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def getPath(self, guest):
    # expand ~ with current user directory
    return guest.getConfig().getVmPath() + guest.getConfig().getFQDN() + ".vmx"

  def isWritten(self, guest):
    return os.path.isfile(self.getPath(guest))

  def write(self, guest):
    if not self.isWritten(guest):
      # need to beautify this
      s = Template("""#!/usr/bin/vmware
.encoding = "UTF-8"

msg.autoAnswer = "true"
guestOS = "$guestOs"
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
        guestOs =guest.getConfig().getGuestOs(),
        fqdn =guest.getConfig().getFQDN(),
        cpu = guest.getConfig().getHardwareCpu(),
        memory = guest.getConfig().getHardwareMemory(),
        extendedConfigFile = self.getPath(guest) + "f",
        diskFile = self.hypervisor.disk.getPath(guest),
        installMedium = guest.getConfig().getInstallMedium(),
        numSharedFolders = len(guest.getConfig().getSharedFolders())
      )

      # find out how to do this in string.Template
      # append shared folders
      i = 0
      for sharedFolder in guest.getConfig().getSharedFolders():
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
      for interface in guest.getConfig().getNetworkInterfaces():
        
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

      with open(self.getPath(guest), "w") as configFile:
        configFile.write("%s" % substitutedConfig)
      
      print('write vmx Config file')