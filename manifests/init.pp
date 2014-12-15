class gitlab {

	$dependencies = [
		'openssh-server',
		'postfix',
		'wget'
	]

	package {$dependencies:
		ensure => installed,
	}

	file { '/opt/gitlab':
		ensure => directory,
	}

	file { '/opt/gitlab/install.sh':
		ensure => file,
		source => "puppet:///modules/${module_name}/opt/gitlab/install.sh"
	}

	exec { 'gitlab-install':
		command => '/bin/bash /opt/gitlab/install.sh; exit 0;',
		onlyif  => "/usr/bin/apt-show-versions gitlab | /bin/grep 'not installed'"
	}
}