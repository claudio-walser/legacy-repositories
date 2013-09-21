class component-common::security {	
	
	# some helpfull packages
	package { "fail2ban": 
		ensure => installed,
		require => Package ['openssh-server']
	} ->

	# disable ssh root login
	# therefore, just copy a configured sshd_config
	file {'/etc/ssh/sshd_config':
		owner => 'root',
		group => 'root',
		ensure  => file,
		mode	=> 0644,
		source => "puppet:///modules/component-common/etc/ssh/sshd_config"
	} ->

	service { "ssh":
		ensure => running
	}

}