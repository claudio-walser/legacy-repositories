class gitlab::ci (
	$backup_dir = '/var/opt/gitlab/backups/',
	$url = $::fqdn,
	$gitlab_server_urls = []
) {

	ensure_resource('class', 'gitlab::actions', {})	
	ensure_resource('class', 'gitlab::install', {})	

	# default stuff you have to do to run gitlab-ci
	file_line { '/etc/gitlab/gitlab.rb-ci_external_url':
		path => '/etc/gitlab/gitlab.rb',
		line => "ci_external_url = 'http://${url}'",
		require => File['/etc/gitlab/gitlab.rb'],
		notify  => Exec['gitlab-reconfigure']
	}
	# omnibus fix
	ensure_resource('class', 'gitlab::fixes::gitlab-ci', {
		url => $url
	})	

	# execute rake task to setup gitlab-ci
	exec { 'gitlab-ci-setup':
		command	=> '/usr/bin/gitlab-ci-rake setup',
		refreshonly => true,
		require => Exec['gitlab-reconfigure']
	}


	# ci only if some gitlab_server_urls got passed
	if empty($gitlab_server_urls) == false {
		# put it in configs anyway, even if it dont work
		file_line { '/etc/gitlab/gitlab.rb-external_url':
			path => '/etc/gitlab/gitlab.rb',
			line => "external_url = 'no-url.${url}'",
			require => File['/etc/gitlab/gitlab.rb'],
			notify  => Exec['gitlab-reconfigure']
		}
		# omnibus fix
		ensure_resource('class', 'gitlab::fixes::gitlab', {
			url => "no-url.${url}"
		})			
		
		file_line { '/etc/gitlab/gitlab.rb-unicorn-disable':
			path => '/etc/gitlab/gitlab.rb',
			line => "unicorn['enable'] = false",
			require => File['/etc/gitlab/gitlab.rb'],
			notify  => Exec['gitlab-reconfigure']
		}
		
		file_line { '/etc/gitlab/gitlab.rb-sidekiq-disable':
			path => '/etc/gitlab/gitlab.rb',
			line => "sidekiq['enable'] = false",
			require => File['/etc/gitlab/gitlab.rb'],
			notify  => Exec['gitlab-reconfigure']
		}

		$gitlab_server_urls_string = join($gitlab_server_urls, "','")
		file_line { '/etc/gitlab/gitlab.rb-gitlab_ci-gitlab_server_urls':
			path => '/etc/gitlab/gitlab.rb',
			line => "gitlab_ci['gitlab_server_urls'] = ['${gitlab_server_urls_string}']",
			require => File['/etc/gitlab/gitlab.rb'],
			notify  => Exec['gitlab-reconfigure']
		}
	}
	
}