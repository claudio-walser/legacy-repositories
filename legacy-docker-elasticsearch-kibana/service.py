#!/usr/bin/python3
# PYTHON_ARGCOMPLETE_OK

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
    containers = []

    def getContainer(self):
        containerList = self.cli.execute("./manage.py list")
        containers = containerList.split("\n")
        return containers

    def dispatch(self, command):
        self.containers = self.getContainer()

        for container in self.containers:
            print("Call %s for container %s" % (command, container))
            print("")
            print(self.cli.execute("./manage.py %s %s" % (command, container)))
            print("")
            print("")

parser = argparse.ArgumentParser()

parser.add_argument(
    "command",
    help="Command to call.",
    type=str,
    choices=[
        "start",
        "stop",
        "restart",
        "status",
        "backup"
    ]
)

argcomplete.autocomplete(parser)


if __name__ == '__main__':
    arguments = parser.parse_args()
    command = arguments.command
    service = Service()
    service.dispatch(command)

    sys.exit(0)