#!/usr/bin/env python3

import os
import subprocess


class Ssh(object):

  def login(self, guest):
    host = guest.username + "@" + guest.ipaddress
    command = [
      "ssh",
      host
    ]     

    ssh = subprocess.Popen(command)
    ssh.communicate()

  def command(self, guest, command, nohup = False):
    host = guest.username + "@" + guest.ipaddress
    if nohup:

      command = [
      "nohup",
        "ssh",
        host,
        command
      ]

    else:
      command = [
        "ssh",
        host,
        command
      ]
    ssh = subprocess.Popen(command,
                           shell=False,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
    stdout, stderr = ssh.communicate()
    code = ssh.wait()

    if code == 0 and type(stdout) is bytes:
      return stdout.decode("utf-8").strip()
    else:
      return stderr.decode("utf-8").strip()

  """
  Exit Codes:
    255 - WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! - ssh-keygen -f "~/.ssh/known_hosts" -R guest.ipaddress
  """
  def hasPublicKey(self, guest, alreadyRecursive = False):
    host = guest.username + "@" + guest.ipaddress
    ssh = subprocess.Popen(["ssh", "-o PasswordAuthentication=no ", host, "whoami"],
                             shell=False,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE)
    
    stdout, stderr = ssh.communicate()
    exitCode = ssh.wait()

    if exitCode == 0:
      # stdout should also match the current guest.username, should maybe check that as well
      # on the other hand, if its zero its okay anyways
      return True

    # just try it once in case of error
    if alreadyRecursive == True:
      return False

    if exitCode == 255:
      #todo maybe i should set this into a config option - think about it
      if self.removeGuestFromKnownHosts(guest) == True:
        return self.hasPublicKey(guest, True)

    return False



  def removeGuestFromKnownHosts(self, guest):
    command = [
      "ssh-keygen",
      "-f",
      os.path.expanduser("~/.ssh/known_hosts"),
      "-R",
      guest.ipaddress
    ]
    process = subprocess.Popen(command,
                     shell=False,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)

    stdout, stderr = process.communicate()
    exitCode = process.wait()

    return exitCode == 0