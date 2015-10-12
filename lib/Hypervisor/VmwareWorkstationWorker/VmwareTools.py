
import subprocess

class VmwareTools(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def __hasOpenVmTools(self, box):
    if self.hypervisor.isRunning(box):
      command = [
        "vmrun",
        "checkToolsState",
        self.hypervisor.vmx.getPath(box)
      ]

      try:
        processOutput = subprocess.check_output(command)
      except:
        return False
        
      if type(processOutput) is bytes:
        processOutputString = processOutput.decode("utf-8")
        toolsState = processOutputString.split("\n")
        return "running" in toolsState
    return False

  # sloooooooowww
  def hasRealVmwareToolsInstalled(self, box):
    # FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');
    if not self.__hasOpenVmTools(box):
      raise Exception('VmwareToolsException', 'No open-vm-tools installed, installation aborted')

    if self.hypervisor.isRunning(box):
      command = [
        "vmrun",
        "-gu",
        box.getUser(),
        "-gp",
        box.getPass(),
        "directoryExistsInGuest",
        self.hypervisor.vmx.getPath(box),
        "/mnt/hgfs"
      ]
      
      try:
        processOutput = subprocess.check_output(command)
      except:
        return False
        
      if type(processOutput) is bytes:
        processOutputString = processOutput.decode("utf-8")
        hasDirectory = processOutputString.split("\n")
        return "The directory exists." in hasDirectory
    return False


  def installVmWareTools(self, box):
    print(box.getHostname() + " is going to receive vmware-tools")
    
    #apt-get --yes install eject
    #eject

    if self.isRunning(box):
      command = [
        "vmrun",
        "installTools",
        self.vmx.getPath(box)
      ]
      try:
        subprocess.check_output(command)
        #mkdir /tmp/cdrom
        #mkdir /tmp/vmware-tools
        #mount /dev/cdrom /tmp/cdrom
        #cp /tmp/cdrom/VM*tar.gz /tmp/vmware-tools/vmware-tools.tar.gz
        #cd /tmp/vmware-tools/
        #tar -xvzf vmware-tools.tar.gz
        #cd vmware-tools-distrib
        #chmod +x vmware-install.pl
        #./vmware-install.pl -d
        #command = [
        #  "vmrun",
        #  "runScriptInGuest",
        #  self.vmx.getPath(box),
        #  "mkdir /tmp/cdrom \
        #  mount /dev/cdrom /tmp/cdrom "
        #]
      except:
        raise Exception('VmwareToolsException', 'Unable to install vmware-tools, installation aborted')