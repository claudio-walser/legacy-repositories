define service-bind9::record::cname (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$host = $::hostname,
	$cname = $::ipaddress_eth0
) {

	
	concat::fragment { "service-bind9::record::cname-${name}":
		target  => $hostsfile,
		content => "${cname}				CNAME		${host}",
		order   => '06'
	}
}
