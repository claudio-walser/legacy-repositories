#!/usr/bin/env python3
# PYTHON_ARGCOMPLETE_OK

import sys
import os
import argcomplete
import json
import argparse
import subprocess
from pprint import pprint


class Cli(object):

    def execute(self, command: str):
        process = subprocess.Popen(
            command,
            shell=True,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        output, err = process.communicate()
        if process.returncode != 0:
            return False

        return output.decode("utf-8").strip()

class Container(object):

    containerId = False
    containerName = False
    isStarted = False
    cli = Cli()
    settings = {}

    def __init__(self, containerName):
        self.containerName = containerName
        if not self.cidfileExists():
            raise Exception("Container CID File does not exists, create it first by using manage.py create %s" % containerName)

        with open("cids/%s.cid" % self.containerName, 'r') as f:
            self.containerId = f.read()

        if not self.exists():
            raise Exception("Container does not exists, create it first by using manage.py create %s" % containerName)
        

    def cidfileExists(self):
        return os.path.isfile("cids/%s.cid" % self.containerName)

    def exists(self):
        output = self.cli.execute("docker inspect %s" % self.containerId)
        if output is False:
            return False
        self.settings = json.loads(output)[0]
        #pprint(self.settings)
        return True

    def isRunning(self):
        return self.settings["State"]["Running"]

    def getIpAddress(self):
        return self.settings["NetworkSettings"]["IPAddress"]

    def getId(self):
        return self.containerId

    def getName(self):
        return self.containerName

class Manager (object):

    container = False
    cli = Cli()

    def getAvailableCommands(self):
        return [
            "buildImage",
            "status",
            "create",
            "start",
            "stop",
            "restart",
            "destroy"
        ]

    def getAvailableContainers(self):
        cidFiles = os.listdir("cids/")
        cidFiles = [cidFile.replace('.cid', '') for cidFile in cidFiles]
        cidFiles.append('*')
        return cidFiles  

    def dispatch(self, command, containerName):
        try:
            methodToCall = getattr(self, command)  
        except:
            # todo: call exception
            raise Exception("Command <%s> not found!" % command)
            sys.exit(1)
        if command == 'create':
            result = methodToCall(containerName)            
        else:
            print("command %s" % command)
            self.container = Container(containerName)
            result = methodToCall()



    # actions
    def status(self):
        print("Container Info")
        print("Name: %s" % self.container.getName())
        print("ID: %s" % self.container.getId())
        print("Running: %s" % self.container.isRunning())
        print("IPAddress: %s" % self.container.getIpAddress())

    def create(self, containerName):
        if not os.path.isdir("indicies/%s" % containerName):
            self.cli.execute("cp -R indicies/elasticsearch-basic indicies/%s" % containerName)
        try:
            self.container = Container(containerName)
        except Exception as e:
            self.cli.execute("docker run -d -it \
                --cidfile=cids/%s.cid \
                --name=%s \
                --hostname=%s \
                -v %s/indicies/%s:/var/lib/elasticsearch/ \
                elasticsearch-kibana:latest \
                /bin/bash;" % (containerName, containerName, containerName, os.path.dirname(os.path.realpath(__file__)), containerName))
            # add hosts entry
        pass



manager = Manager()
#pprint(manager.getAvailableCommands())
#pprint(manager.getAvailableContainers())


if len(sys.argv) == 2:
    # default branch name is *
    sys.argv.append('*')

# create parser in order to autocomplete
parser = argparse.ArgumentParser()

parser.add_argument(
    "command",
    help="Command to call.",
    type=str,
    choices=manager.getAvailableCommands()
)
parser.add_argument(
    "container",
    help="Name of your container",
    type=str#,
)
argcomplete.autocomplete(parser)


if __name__ == '__main__':
    arguments = parser.parse_args()
    command = arguments.command
    container = arguments.container
    manager.dispatch(command, container)
    sys.exit(0)