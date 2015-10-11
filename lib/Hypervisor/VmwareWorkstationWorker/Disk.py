
import os
import subprocess

class Disk(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def getPath(self, box):
    return box.getVmPath() + box.getFQDN() + ".vmdk"

  def has(self, box):
    return os.path.isfile(self.getPath(box))

  def create(self, box):
    if not self.has(box):
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
        self.getPath(box)
      ]

      print(subprocess.check_output(command))