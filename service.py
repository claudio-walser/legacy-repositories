#!/usr/bin/env python3


import argparse
import argcomplete
import subprocess
import sys
from pprint import pprint

class Cli(object):

    def execute(self, command):
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

class Service(object):

    cli = Cli()

    def getContainer(self):
        containerList = self.cli.execute("./manage.py list")
        containers = containerList.split("\n")
        return containers

    def dispatch(self, command):
        containers = self.getContainer()
        result = False
        try:
            methodToCall = getattr(self, command)  
        except:
            # todo: call exception
            raise Exception("Command <%s> not found!" % command)
            sys.exit(1)
        if command == 'create' or command == 'list':
            result = methodToCall(containerName)            
        else:
            print("command %s" % command)
            self.container = Container(containerName)
            result = methodToCall()

        return result


parser = argparse.ArgumentParser()

parser.add_argument(
    "command",
    help="Command to call.",
    type=str,
    choices=[
        "start",
        "stop",
        "status",
        "backup"
    ]
)

argcomplete.autocomplete(parser)


if __name__ == '__main__':
    arguments = parser.parse_args()
    command = arguments.command
    service = Service()
    service.getContainer()

    sys.exit(0)