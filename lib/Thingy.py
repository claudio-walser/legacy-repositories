#!/usr/bin/env python3

from lib.ConfigParser import ConfigParser
from pprint import pprint

class Thingy(object):
  
  box = '*'

  def __init__(self, box):
    self.box = box
    self.loadConfigFile()   

  def loadConfigFile(self):
    parser = ConfigParser()
    parser.load()
    boxConfig = parser.getConfigForBox(self.box)
    pprint(boxConfig)

  #start|stop|restart|ssh|destroy|status
  def start(self):
    print("Start or even install box " + self.box)

  def stop(self):
    print("stop box " + self.box)

  def restart(self):
    print("restart box " + self.box)

  def ssh(self):
    print("ssh into box " + self.box)	

  def destroy(self):
    print("destroy box " + self.box)

  def status(self):
    print("status of box " + self.box)

