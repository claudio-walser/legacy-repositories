class component-common::administrators {

	## need package sudo to add users to sudoers
	package { "sudo": 
		ensure => installed 
	} ->

	## admin user
	user { 'admin': 
        groups     => 'sudo', 
        comment     => 'Administrator', 
        ensure      => present, 
        home        => '/home/admin', 
        shell       => '/bin/bash', 
        managehome  => true,
        password    => '$6$OprdC8Il$YuxNRSVU0cf1wMSp8bbnav8fWc5kwEk2N4nsbnJ7G8BWqwbUeH33kRRZpM4DETeQ1va02b21a07zp66DnwL/a0'
    } ->

    file { '/home/admin/.ssh':
        ensure => "directory",
        owner  => "admin",
        group  => "admin",
        mode   => 755
    } ->

    # authorized server admins - add public keys in this file
    file {'/home/admin/.ssh/authorized_keys':
        owner => 'admin',
        group => 'admin',
        ensure  => file,
        mode    => 0644,
        source => "puppet:///modules/component-common/home/admin/.ssh/authorized_keys";
    } ->

    # no password prompt for user admin while using sudo
    file { '/etc/sudoers.d/admin':
        ensure => 'file',
        owner => 'root',
        group => 'root',
        content => 'admin ALL=NOPASSWD:ALL'
    }

}
