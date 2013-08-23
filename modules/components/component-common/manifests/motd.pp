class component-common::motd {
	
	# default motd
	file {'/etc/motd':
		ensure  => file,
		mode	=> 0644,
		content => template("component-common/etc/motd.erb")
	}

}