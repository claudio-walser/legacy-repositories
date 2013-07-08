class common::motd {
	
	# default motd
	file {'/etc/motd':
		ensure  => file,
		mode	=> 0644,
		source => "puppet:///modules/common/etc/motd"
	}

}