class gitlab (
	$data_dir = '/var/opt/gitlab/git-data/',
	$backup_dir = '/var/opt/gitlab/backups/',
	$url = $::fqdn,
) {

	ensure_resource('class', 'gitlab::actions', {})	
	ensure_resource('class', 'gitlab::install', {})	

	# do default gitlab configuration
	file_line { '/etc/gitlab/gitlab.rb-external_url':
		path => '/etc/gitlab/gitlab.rb',
		line => "external_url = '${url}'",
		require => File['/etc/gitlab/gitlab.rb'],
		notify  => Exec['gitlab-reconfigure']
	}
	ensure_resource('class', 'gitlab::fixes::gitlab', {
		url => $url
	})

	file_line { '/etc/gitlab/gitlab.rb-git_data_dir':
		path => '/etc/gitlab/gitlab.rb',
		line => "git_data_dir = '${data_dir}'",
		require => File['/etc/gitlab/gitlab.rb'],
		notify  => Exec['gitlab-reconfigure']
	}

}