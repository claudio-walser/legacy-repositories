class service-nessus {

	# 40FD-395C-19F6-2B1A-0537
	exec { 'nessus-installation' :
		command => 'dpkg -i /mnt/backup/development.claudio.dev/scan/backup/files/packages/Nessus-5.2.4-debian6_amd64.deb',
		path => '/usr/bin',
		creates => '/etc/init.d/nessusd',
		require => [
			Exec['backup-mount']
		]
	}

}
