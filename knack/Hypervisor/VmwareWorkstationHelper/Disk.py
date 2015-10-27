#!/usr/bin/env python3

import os
import subprocess

class Disk(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def getPath(self, guest):
    return guest.getVmPath() + guest.getFQDN() + ".vmdk"

  def has(self, guest):
    return os.path.isfile(self.getPath(guest))

  def create(self, guest):
    if not self.has(guest):
      # /usr/bin/vmware-vdiskmanager -c -t 0 -s $SIZE -a ide $VM_PATH/$FQDN.vmdk;
      command = [
        "vmware-vdiskmanager",
        "-c",
        "-t",
        "0",
        "-s",
        guest.getHardwareDisk(),
        "-a",
        "ide",
        self.getPath(guest)
      ]

      print(subprocess.check_output(command))