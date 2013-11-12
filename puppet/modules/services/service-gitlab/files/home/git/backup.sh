/bin/mkdir -p /mnt/backup/development.claudio.dev/git/backup/files/latest/home/git/repositories;
/usr/bin/rsync -av /home/git/repositories /mnt/backup/development.claudio.dev/git/backup/files/latest/home/git/;

/bin/mkdir -p /mnt/backup/development.claudio.dev/git/backup/mysql/latest/
/usr/bin/mysqldump -ugitlab -pgitlab gitlab > /mnt/backup/development.claudio.dev/git/backup/mysql/latest/gitlab.sql

exit 0;