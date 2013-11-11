/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/plugin_assets /opt/redmine/public/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/public/themes /opt/redmine/public/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/plugins /opt/redmine/;

/bin/cp -r /mnt/backup/development.claudio.dev/wiki/backup/files/latest/opt/redmine/db/migrate /opt/redmine/db/;


cd /opt/redmine;
/usr/local/bin/bundle install --without development test postgresql sqlite
/usr/local/bin/rake generate_secret_token
RAILS_ENV=production /usr/local/bin/rake db:migrate
RAILS_ENV=production /usr/local/bin/rake redmine:load_default_data


/bin/chmod -R 0777 /opt/redmine/public/system/rich/rich_files/rich_files

/usr/bin/mysql -uredmine -predmine redmine < /mnt/backup/development.claudio.dev/wiki/backup/mysql/latest/redmine-2.sql

exit 0;
