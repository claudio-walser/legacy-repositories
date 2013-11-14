class component-common::mounts {
    # get role name	
	$node_role = get_node_role($hostname)


    exec { 'backup-directory':
        command => "mkdir -p /mnt/backup/",
        path => '/bin',
        creates => '/mnt/backup/'
    }
	
    package { 'cifs-utils':
		ensure => 'installed',
        require => Exec['backup-directory']
	}
	
	exec { 'backup-mount':
        command => "mount -t cifs //10.20.0.3/backup /mnt/backup/ -o username=backup,password=backup,domain=QNAP",
        path => '/bin',
        creates => '/mnt/backup/keep',
        require => Package['cifs-utils']
    }

    # create one backup directory by role
	exec { 'backup-directory-backup':
        command => "mkdir -p /mnt/backup/${domain}/${node_role}/backup",
        path => '/bin',
        creates => '/mnt/backup/${domain}/${node_role}/backup',
        require => Exec['backup-mount']
    }

}
