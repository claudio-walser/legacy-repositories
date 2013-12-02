#!/bin/bash

/bin/mkdir -p /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/plugin_assets;
/usr/bin/rsync -av /opt/redmine/public/plugin_assets /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/;

/bin/mkdir -p /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/themes;
/usr/bin/rsync -av /opt/redmine/public/themes /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/;

/bin/mkdir -p /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/plugins;
/usr/bin/rsync -av /opt/redmine/plugins /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/;

/bin/mkdir -p /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/db/migrate;
/usr/bin/rsync -av /opt/redmine/db/migrate /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/db/;

/usr/bin/mysqldump -uredmine -predmine redmine > /mnt/backup/development.claudio.dev/wiki/backup/mysql/latest/redmine-2.sql

exit 0;