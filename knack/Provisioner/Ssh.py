Ssh.py


  def ssh(self, guest):
    self.ipaddress = self.hypervisor.getGuestIPAddress(self)
    if not self.hasPublicKey():
      self.copyPublicKey()

    if self.__ssh("hostname") != self.getHostname():
      self.__ssh("hostname %s" % self.getHostname())

    print(self.__ssh("hostname"))


  def __ssh(self, command):
    host = self.username + "@" + self.ipaddress
    ssh = subprocess.Popen(["ssh", "%s" % host, command],
                       shell=False,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()
    if result == []:
      print("Error")
      return False
    else:
      return result[0].decode("utf-8").strip()

  # should do that maybe in a seperate ssh class
  def copyPublicKey(self):
    source = os.path.expanduser(self.publicKey)

    if self.username == "root":
      targetDirectory = "/root/.ssh/"
    else:
      targetDirectory = "/home/%s/.ssh/" % self.username
    
    target = targetDirectory + "authorized_keys"
    
    self.hypervisor.ensureDirectory(self, targetDirectory)
    self.hypervisor.copyFile(self, source, target)

  def hasPublicKey(self):
    host = self.username + "@" + self.ipaddress
    ssh = subprocess.Popen(["ssh", "-o PasswordAuthentication=no ", "%s" % host, "whoami"],
                       shell=False,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
    result = ssh.stdout.readlines()
    if result == []:
      return False
    else:
      return True