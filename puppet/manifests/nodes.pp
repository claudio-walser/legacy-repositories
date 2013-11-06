## nodes.pp

### default node handles everything by hostname
node default {
	# include defaul rend do common stuff
	include role

	# fetch node role and node number out of hostname. Match example:
	# (anything-but-last-one-or-two-numbers-is-the-role)-01
	if $hostname =~ /(.*)-([\d]{1,2})$/ {
		$node_role = $1
		$node_number = $2

		$role_class  = "role::$node_role"
		include $role_class
	}
	
}

