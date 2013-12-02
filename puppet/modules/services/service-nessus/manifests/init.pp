class service-nessus {

	package { 'nessus' :
		ensure => 'installed',
		source => '/mnt/backup/development.claudio.dev/scan/backup/files/packages/Nessus-5.2.4-debian6_amd64.deb',
		require => [
			Exec['backup-mount']
		]
	}

}
