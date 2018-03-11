#!/usr/bin/python3
# PYTHON_ARGCOMPLETE_OK

import sys
import os
import argcomplete
import json
import argparse
import subprocess
from pprint import pprint
import re
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


class Nginx(object):
    cli = Cli()
    template = "    location /%s { \n\
      auth_basic \"Protected Elasticsearch\"; \n\
      auth_basic_user_file /etc/nginx/elasticsearch.d/%s; \n\
      rewrite ^/%s(.*) /$1 break; \n\
      proxy_pass http://%s:9200; \n\
    } \n\
 \n\
    location /%s/kibana { \n\
      auth_basic \"Protected Elasticsearch\"; \n\
      auth_basic_user_file /etc/nginx/elasticsearch.d/%s; \n\
      rewrite ^/%s/kibana/(.*) /$1 break; \n\
      proxy_pass http://%s:5601; \n\
    }"


    def writeConfig(self, containerName):
        configString = self.template % (containerName, containerName, containerName, containerName, containerName, containerName, containerName, containerName)
        with open("/etc/nginx/elasticsearch.d/%s.conf" % containerName, "w") as configFile:
            configFile.write(configString)
        self.cli.execute("service nginx reload")

    def removeConfig(self, containerName):
        self.cli.execute("rm /etc/nginx/elasticsearch.d/%s.conf" % containerName)
        self.cli.execute("service nginx reload")

class BasicAuth(object):

    cli = Cli()

    def write(self, containerName):
        pw = self.cli.execute("pwgen --capitalize --numerals --symbols -1 32 1")
        self.cli.execute("printf \"%s:$(openssl passwd -crypt '%s')\" > /etc/nginx/elasticsearch.d/%s" % (containerName, pw, containerName))
        print("%s:%s" % (containerName, pw))

    def remove(self, containerName):
        self.cli.execute("rm  /etc/nginx/elasticsearch.d/%s" % (containerName))

class HostsFile(object):
    cli = Cli()
    def add(self, ip, hostname):
        with open("/etc/hosts", 'r+') as f:
            hostsfile = f.read()
            pprint(hostsfile.find(hostname))
            if hostsfile.find(hostname) is not -1:
                hostsfile = re.sub(r"\n(.*)    %s\n" % hostname, "\n%s    %s\n" % (ip, hostname), hostsfile)
                #self.cli.execute("sed -i 's/.*    %s/%s    %s/g' /etc/hosts" % (hostname, ip, hostname))
            else:
                hostsfile += "%s    %s\n" % (ip, hostname)
                #self.cli.execute("echo '%s    %s' >> /etc/hosts" % (ip, hostname))
            f.seek(0)
            f.write(hostsfile)
            f.truncate()

    def remove(self, hostname):
        with open("/etc/hosts", 'r+') as f:
            hostsfile = f.read()
            pprint(hostsfile.find(hostname))
            if hostsfile.find(hostname) is not -1:
                hostsfile = re.sub(r"\n(.*)    %s\n" % hostname, "\n", hostsfile)
                #self.cli.execute("sed -i 's/.*    %s/%s    %s/g' /etc/hosts" % (hostname, ip, hostname))
            f.seek(0)
            f.write(hostsfile)
            f.truncate()


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
            self.cli.execute("rm cids/%s.cid" % self.containerName)
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

    def loadConfig(self):
        self.exists()

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
    nginx = Nginx()
    hostsFile = HostsFile()
    basicAuth = BasicAuth()

    def getAvailableCommands(self):
        return [
            "buildImage",
            "list",
            "backup",
            "restore",
            "status",
            "create",
            "start",
            "stop",
            "restart",
            "destroy"
        ]

    def getAvailableContainers(self):
        cidFiles = os.listdir("cids")
        files = []
        for cidFile in cidFiles:
            if cidFile.endswith(".cid"):
                files.append(cidFile.replace('.cid', ''))
        files.append('*')
        return files

    def dispatch(self, command, containerName):
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

    # actions

    def list(self, dummy):
        containers = self.getAvailableContainers()
        # remove wildcard
        containers.pop()
        for container in containers:
            print(container)

        return True

    def backup(self):
        if os.path.isdir("indicies-backup/%s" % self.container.getName()):
            self.cli.execute("mv indicies-backup/%s indicies-backup/%s-old" % (self.container.getName(), self.container.getName()))
        
        self.cli.execute("cp -R indicies/%s indicies-backup/%s" % (self.container.getName(), self.container.getName()))

        if os.path.isdir("indicies-backup/%s-old" % self.container.getName()):
            self.cli.execute("rm -rf indicies-backup/%s-old" % self.container.getName())

    def restore(self):
        if os.path.isdir("indicies-backup/%s" % self.container.getName()):
            if os.path.isdir("indicies/%s" % self.container.getName()):
                self.cli.execute("rm -rf indicies/%s" % self.container.getName())
            self.cli.execute("cp -R indicies-backup/%s indicies/%s" % (self.container.getName(), self.container.getName()))
        else:
            print("No backup found for %s" % self.container.getName())

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
        except:
            print("Creating container")
            self.cli.execute("docker run -d -it \
                --cidfile=cids/%s.cid \
                --name=%s \
                --hostname=%s \
                -v %s/indicies/%s:/var/lib/elasticsearch/ \
                elasticsearch-kibana:latest \
                /bin/bash;" % (containerName, containerName, containerName, os.path.dirname(os.path.realpath(__file__)), containerName))
            
            self.container = Container(containerName)
            self.cli.execute("docker exec %s bash -c \"echo 'server.basePath: \"/%s/kibana\"' >> /opt/kibana/config/kibana.yml\"" % (self.container.getId(), containerName))
            self.start(True)
            self.nginx.writeConfig(containerName)
            self.basicAuth.write(containerName)

    def start(self, writeHostsFile = False):
        if not self.container.isRunning():
            self.cli.execute("docker start %s" % self.container.getId())
            # add hosts entry
            writeHostsFile = True
            
        if writeHostsFile is True:
            self.container.loadConfig()
            self.hostsFile.add(self.container.getIpAddress(), self.container.getName())

        self.cli.execute("docker exec %s chown -R elasticsearch:elasticsearch /var/lib/elasticsearch" % self.container.getId())
        self.cli.execute("docker exec %s service elasticsearch start" % self.container.getId())
        self.cli.execute("docker exec %s service kibana start" % self.container.getId())

        self.status()

    def stop(self):
        if self.container.isRunning():
            self.cli.execute("docker stop %s" % self.container.getId())
            self.container.loadConfig()

    def restart(self):
        self.stop()
        self.start()

    def destroy(self):
        if self.container.cidfileExists():
            self.cli.execute("rm cids/%s.cid" % self.container.getName())
        if os.path.isdir("indicies/%s" % self.container.getName()):
            self.cli.execute("rm -rf indicies/%s" % self.container.getName())
        if self.container:
            self.cli.execute("docker rm -f %s" % self.container.getId())

        self.nginx.removeConfig(self.container.getName())
        self.hostsFile.remove(self.container.getName())
        self.basicAuth.remove(self.container.getName())
        # handle removing hosts entry

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