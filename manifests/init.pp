class gitlab (
	$data_dir = ''
) {

	$dependencies = [
		'openssh-server',
		'postfix',
		'wget'
	]

	package { $dependencies:
		ensure => installed,
	}

	file { '/opt/gitlab':
		ensure => directory,
	}

	file { '/opt/gitlab/source':
		ensure => directory,
	}

	wget::fetch { 'download-gitlab-deb-package':
		source      => 'https://downloads-packages.s3.amazonaws.com/debian-7.6/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		destination => '/opt/gitlab/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		timeout     => 0,
		verbose     => true,
		require 	=> File['/opt/gitlab/source']
	}

	exec { 'gitlab-install':
		command	=> '/usr/bin/dpkg -i /opt/gitlab/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		require	=> Wget::Fetch['download-gitlab-deb-package'],
		onlyif => "/usr/bin/apt-show-versions gitlab | /bin/grep 'not installed'"
	}

	file { '/etc/gitlab/gitlab.rb':
		ensure => file,
		content => template('etc/gitlab/gitlab.rb.erb'),
		notify => Exec['gitlab-reconfigure']
	}

	file { '/opt/gitlab/scripts/restore.sh':
		ensure => file,
		content => template('opt/gitlab/scripts/restore.sh.erb')
	}


	# reconfigure and restart only on refresh
	exec { 'gitlab-reconfigure':
		command	=> '/usr/bin/gitlab-ctl reconfigure',
		onlyrefresh => true,
		notify => Exec['gitlab-restart']
	}

	exec { 'gitlab-restart':
		command	=> '/usr/bin/gitlab-ctl restart',
		onlyrefresh => true
	}
}