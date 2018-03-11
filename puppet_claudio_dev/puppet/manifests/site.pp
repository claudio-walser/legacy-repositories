# Defaults
Exec {
	path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

### default node handles everything by hostname
node default {
	# fetch node role and node number out of hostname. Match example:
	# (anything-but-last-one-or-two-numbers-is-the-role)-01
	$node_role = get_node_role($hostname)
	$node_number = get_node_number($hostname)

	# include default profile
	include role::minimal

	if $node_role and defined("role::${node_role}") {
		include "role::${node_role}"
	}
}