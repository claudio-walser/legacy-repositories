cd /opt/redmine;
/usr/local/bin/bundle install --without development test postgresql sqlite
/usr/local/bin/rake generate_secret_token
RAILS_ENV=production /usr/local/bin/rake db:migrate
RAILS_ENV=production /usr/local/bin/rake redmine:load_default_data


/bin/chmod -R 0777 /opt/redmine/public/system/rich/rich_files/rich_files

/bin/touch /opt/redmine/installed;

exit 0;
