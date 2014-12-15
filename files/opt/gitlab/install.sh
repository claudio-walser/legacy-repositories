#!/bin/bash

wget https://downloads-packages.s3.amazonaws.com/debian-7.6/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb
sudo apt-get install openssh-server
sudo apt-get install postfix
sudo dpkg -i gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb