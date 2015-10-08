#!/usr/bin/env python3

class Thingy(object):

  #start|stop|restart|ssh|destroy|status
  def start(box):
    print("Start or even install box " + box)

  def stop(box):
    print("stop box " + box)

  def restart(box):
    print("restart box " + box)

  def ssh(box):
    print("ssh into box " + box)	

  def destroy(box):
    print("destroy box " + box)

  def status(box):
    print("status of box " + box)

