define service-percona::clusterip (
	$ip,
	$node_number,
	$node_role,
	$hostname
) {
	
	$config_file = '/etc/mysql/my.cnf'
	$order = 2 + $node_number
	
	# last entry should not have a comma
	if is_last_node($node_role, $hostname) {
		$content = "${ip}"
	} else {
		$content = "${ip},"
	}
	
	concat::fragment { "service-percona::my.cnf.cluster-ip-${name}":
		target  => $config_file,
		content => $content,
		order   => "0${order}"
	}	
	
}
