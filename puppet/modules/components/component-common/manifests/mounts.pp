class component-common::mounts {	
	
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
    } #->



    # create one backup directory by role
	#exec { 'backup-directory-backup':
    #    command => "mkdir -p /mnt/backup/${domain}/test-${node_role}/backup",
    #    path => '/bin',
    #    creates => '/mnt/backup/${domain}/test-${node_role}/backup'
    #}

}
