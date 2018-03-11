class profile-minimal::motd {

	# why the heck i dont have my node infos here, hell
	$node_role = get_node_role($hostname)
	$node_number = get_node_number($hostname)

	# default motd
	file {'/etc/motd':
		ensure  => file,
		mode	=> 0644,
		content => template("${module_name}/etc/motd.erb")
	}

}
