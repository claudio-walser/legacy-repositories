
import subprocess
import pprint

class VmwareTools(object):

  hypervisor = False

  def __init__(self, hypervisor):
    self.hypervisor = hypervisor

  def __hasOpenVmTools(self, guest):
    if self.hypervisor.isRunning(guest):
      command = [
        "vmrun",
        "checkToolsState",
        self.hypervisor.vmx.getPath(guest)
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
  def hasRealVmwareToolsInstalled(self, guest):
    # FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');
    if not self.__hasOpenVmTools(guest):
      raise Exception('VmwareToolsException', 'No open-vm-tools installed, installation aborted')

    if self.hypervisor.isRunning(guest):
      command = [
        "vmrun",
        "-gu",
        guest.getConfig().getUser(),
        "-gp",
        guest.getConfig().getPass(),
        "directoryExistsInGuest",
        self.hypervisor.vmx.getPath(guest),
        "/mnt/hgfs",
        "nogui"
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


  def installVmWareTools(self, guest):
    print(guest.getConfig().getHostname() + " is going to receive vmware-tools")
    
    if self.hypervisor.isRunning(guest):
      
      #vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runProgramInGuest "$VM_PATH/$FQDN.vmx" "/vmware-tools/vmware-install.pl -d
      
      command = [
        "vmrun",
         "-gu",
        guest.getConfig().getUser(),
        "-gp",
        guest.getConfig().getPass(),
        "runScriptInGuest",
        self.hypervisor.vmx.getPath(guest),
        guest.getCommandBinary(),
        guest.ejectMediaCommand()
      ] 
      processOutput = subprocess.check_output(command)
      print(processOutput.decode("utf-8"))
      
      try:
        command = [
          "vmrun",
          "installTools",
          self.hypervisor.vmx.getPath(guest)
        ]        
        
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
      except:
        pass
        raise Exception('VmwareToolsException', 'Unable to install vmware-tools, installation aborted')
      
      command = [
        "vmrun",
         "-gu",
        guest.getConfig().getUser(),
        "-gp",
        guest.getConfig().getPass(),
        "runScriptInGuest",
        self.hypervisor.vmx.getPath(guest),
        guest.getCommandBinary(),
        guest.installVmWareToolsCommand()
      ] 
      processOutput = subprocess.check_output(command)
      print(processOutput.decode("utf-8"))
