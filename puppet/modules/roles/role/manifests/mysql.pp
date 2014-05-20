class role::mysql (
	$root_password = '1234'
) {

	if $node_number == 1 {
		$bootstrap = true

		# create databases
		service-percona::database { 'blubb': 
			ensure => 'present',
			root_password => $root_password,
			user => 'test',
			password => 'test',
			grant => 'ALL',
			charset => 'utf8',
			collate => 'utf8_general_ci',
			host => '%'
		}

	} else {
		$bootstrap = false
	}

	class { '::service-percona':
		root_password => $root_password,
		bootstrap => $bootstrap
	}
}