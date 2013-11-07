class component-common::mounts {
    # get role name	
	$node_role = get_node_role($hostname)

	package { 'cifs-utils':
		ensure => 'installed'
	} ->

	exec { 'backup-directory':
        command => "mkdir -p /mnt/backup/",
        path => '/bin',
        creates => '/mnt/backup/'
    } ->

	exec { 'backup-mount':
        command => "mount -t cifs //10.20.0.3/backup /mnt/backup/ -o username=backup,password=backup,domain=QNAP",
        path => '/bin',
        creates => '/mnt/backup/keep'
    } ->

    # create one backup directory by role
	exec { 'backup-directory-backup':
        command => "mkdir -p /mnt/backup/${domain}/${node_role}/backup",
        path => '/bin',
        creates => '/mnt/backup/${domain}/${node_role}/backup'
    }


    # still manual

    # rm -rf /var/www/redmine
    # ln -s /usr/share/redmine/public /var/www/redmine
    # nano /etc/apache2/sites-available/25-wiki-01.development.claudio.dev.conf
    #   content as in service-redmine/files
    # service apache2 restart
}
