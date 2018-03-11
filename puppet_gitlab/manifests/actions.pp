class gitlab::actions {

	# reconfigure and restart only on refresh
	exec { 'gitlab-reconfigure':
		command	=> '/usr/bin/gitlab-ctl reconfigure',
		refreshonly => true,
		notify => Exec['gitlab-restart']
	}
	exec { 'gitlab-restart':
		command	=> '/usr/bin/gitlab-ctl restart',
		refreshonly => true
	}
	
}