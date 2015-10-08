#!/usr/bin/env python3

from lib.ConfigParser import ConfigParser

class Thingy(object):
  def __init__(self):
    print('înit')
    self.loadConfigFile()

  def loadConfigFile(self, ):
    ConfigParser.parse()

  #start|stop|restart|ssh|destroy|status
  def start(self, box):
    print("Start or even install box " + box)

  def stop(self, box):
    print("stop box " + box)

  def restart(self, box):
    print("restart box " + box)

  def ssh(self, box):
    print("ssh into box " + box)	

  def destroy(self, box):
    print("destroy box " + box)

  def status(self, box):
    print("status of box " + box)

