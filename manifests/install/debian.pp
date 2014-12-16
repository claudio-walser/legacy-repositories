class gitlab::install::debian {

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

}