class gitlab::install::debian {

	# install package dependencies
	$dependencies = [
		'openssh-server',
		'postfix',
		'wget',
		'apt-show-versions'
	]
	ensure_resource('package', $dependencies, {
		ensure => installed
	})	

	wget::fetch { 'download-gitlab-deb-package':
		source      => 'https://downloads-packages.s3.amazonaws.com/debian-7.6/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		destination => '/opt/gitlab/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		timeout     => 0,
		verbose     => true,
		require 	=> File['/opt/gitlab/source']
	}

	exec { 'gitlab-install':
		command	=> '/usr/bin/dpkg -i /opt/gitlab/gitlab_7.5.3-omnibus.5.2.1.ci-1_amd64.deb',
		onlyif => "/usr/bin/apt-show-versions gitlab | /bin/grep 'not installed'",
		require	=> [Wget::Fetch['download-gitlab-deb-package'], Package['apt-show-versions']]
	}

}