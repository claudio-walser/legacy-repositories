define service-bind9::record::cname (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$targethost = $::hostname,
	$ip = $::ipaddress_eth1
) {

	
	concat::fragment { "service-bind9::record::cname-${name}":
		target  => $hostsfile,
		content => "${name}				CNAME		${targethost}",
		order   => '06'
	}
}
