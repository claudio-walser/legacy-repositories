# Defaults
Exec {
	path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}


### default node handles everything by hostname
node default {
	# include default profile
	include role::minimal

	# fetch node role and node number out of hostname. Match example:
	# (anything-but-last-one-or-two-numbers-is-the-role)-01
	$node_role = get_node_role($hostname)
	if $node_role {
		$node_number = get_node_number($hostname)
		include "role::$node_role"
	}
	
}