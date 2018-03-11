class service-php-fpm {

	$member = $network['members'][$hostname]
    $staticEth = $network['staticEth']
    $fixedIp = $member[$staticEth]

	include php::fpm::daemon
	php::fpm::conf { "${::fqdn}":
		listen  => "${fixedIp}:9001",
		listen_allowed_clients => "10.20.1.31",
		user => 'www-data'
	}

}
