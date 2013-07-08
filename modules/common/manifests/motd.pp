class common::motd {
	
	# default motd
	file {'motd':
		ensure  => file,
		path	=> '/etc/motd',
		mode	=> 0644,
		source => "puppet:///modules/common/etc/motd"
	}

}