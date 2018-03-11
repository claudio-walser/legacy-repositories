class role::gitlab {
	class {'::gitlab':
		data_dir => '/var/opt/gitlab/git-data/',
		backup_dir => '/var/opt/gitlab/backups/',
		url => $::fqdn		
	}

}