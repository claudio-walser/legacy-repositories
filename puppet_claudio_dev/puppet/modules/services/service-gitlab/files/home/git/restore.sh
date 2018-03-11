#!/bin/bash

/bin/cp -a /mnt/backup/development.claudio.dev/git/backup/files/latest/home/git/repositories /home/git/;

/usr/bin/mysql -ugitlab -pgitlab gitlab < /mnt/backup/development.claudio.dev/git/backup/mysql/latest/gitlab.sql

exit 0;