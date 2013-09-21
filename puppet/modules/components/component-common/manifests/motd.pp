class component-common::motd {
	
	$fixed_ip = get_host_ip($network)

	# default motd
	file {'/etc/motd':
		ensure  => file,
		mode	=> 0644,
		content => template("component-common/etc/motd.erb")
	}

}