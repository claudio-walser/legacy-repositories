class role::mysql (
	$root_password = '1234',
	$databases = {}
) {

	if is_first_node($node_role, $hostname) {
		$bootstrap = true
		
		# create databases from hiera
		if is_hash($databases) {
			create_resources( 'service-percona::database', $databases, {
				root_password => $root_password
			})
		}
		
	} else {
		$bootstrap = false
	}


	class { '::service-percona::server':
		root_password => $root_password,
		bootstrap => $bootstrap
	}
}