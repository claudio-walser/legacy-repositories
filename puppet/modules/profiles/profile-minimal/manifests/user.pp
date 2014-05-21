define profile-minimal::user (
	$ensure = 'present',
	$username = $name,
	$password = '',
	$groups = '',
	$shell = '/bin/bash',
	$ssh_key = '',
	$no_passwd = false
) {

	if (empty($password)) and ($no_passwd != true) {
		fail('You cannot have no_passwd to false without setting a password then')
	}

	user { $username: 
		groups     => $groups,
		ensure      => $ensure,
		home        => "/home/${username}",
		shell       => $shell,
		managehome  => true,
		password    => $password
	}

	file { "/home/${username}/.ssh":
		ensure => "directory",
		owner  => $username,
		group  => $username,
		mode   => 755,
		require => User[$username]
	}

	# limitation: just one ssh key per user yet
	file { "/home/${username}/.ssh/authorized_keys":
		owner => $username,
		group => $username,
		ensure  => file,
		mode    => 0644,
		content => $ssh_key,
		require => File["/home/${username}/.ssh"]
	}


	# make sudo without pw
	if $no_passwd == true {
		# no password prompt for user admin while using sudo
		file { "/etc/sudoers.d/${username}":
			ensure => 'file',
			owner => 'root',
			group => 'root',
			content => "${username} ALL=NOPASSWD:ALL"
		}
	}

	# root bashrc for avoiding some errors
	file { '/root/.bashrc':
		ensure => 'file',
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/${module_name}/root/.bashrc"
	}

}