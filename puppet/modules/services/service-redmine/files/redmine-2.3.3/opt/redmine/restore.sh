/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/plugin_assets /opt/redmine/public/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/themes /opt/redmine/public/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/plugins /opt/redmine/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/db/migrate /opt/redmine/db/;

/usr/bin/mysql -uredmine -predmine redmine < /mnt/backup/development.claudio.dev/wiki/backup/mysql/latest/redmine-2.sql

exit 0;
