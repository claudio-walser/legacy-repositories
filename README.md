Puppet module to install gitlab - debian only right now

Usage
-----

class {'::gitlab':
	'data_dir'   => '/var/opt/gitlab/git-data/',
	'backup_dir' => '/mnt/backup/gitlab/'
}

Backup
------
#### Create Backup
    sudo gitlab-rake gitlab:backup:create

Restore
-------
#### Restore Backup
    sudo gitlab-rake gitlab:backup:restore
