define service-bind9::record::a (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$ip = $::ipaddress_eth1
) {

	
	concat::fragment { "service-bind9::record::a-${name}":
		target  => $hostsfile,
		content => "${name}				A		${ip}",
		order   => '05'
	}
}
