class component-common::motd {
	
	# default motd
	file {'/etc/motd':
		ensure  => file,
		mode	=> 0644,
		source => "puppet:///modules/component-common/etc/motd"
	}

}