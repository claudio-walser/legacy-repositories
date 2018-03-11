define service-bind9::master (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$ip = $::ipaddress_eth0
) {

	
	concat::fragment { $name:
		target  => $hostsfile,
		content => "$name				A		$ip",
		order   => '05'
	}
}
