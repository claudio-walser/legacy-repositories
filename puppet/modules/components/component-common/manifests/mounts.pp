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
        command => "mount -t cifs //10.20.0.3/backup /mnt/backup/ -o username=backup,password=backup,domain=claudio.dev",
        path => '/bin',
        creates => '/mnt/backup/keep'
    } ->

	exec { 'backup-directory-setup':
        command => "mkdir -p /mnt/backup/${domain}/${hostname}/setup",
        path => '/bin',
        creates => '/mnt/backup/${domain}/${hostname}/setup'
    } ->

	exec { 'backup-directory-backup':
        command => "mkdir -p /mnt/backup/${domain}/${hostname}/backup",
        path => '/bin',
        creates => '/mnt/backup/${domain}/${hostname}/backup'
    }

}
