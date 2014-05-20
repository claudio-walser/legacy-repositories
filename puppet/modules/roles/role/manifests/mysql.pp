class role::mysql (
	$root_password = '1234'
) {

	if $node_number == 1 {
		$master = true
	} else {
		$master = false
	}

	class { '::service-percona':
		root_password => $root_password,
		master => $master
	}
}