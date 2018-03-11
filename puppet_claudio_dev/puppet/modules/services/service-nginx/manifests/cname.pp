define service-nginx::cname (
	$cname = $name,
	$host = $::hostname
) {
	#fail($cname)
	@@service-bind9::record::cname{"${host}-${cname}":
		host => $host,
		cname => $cname
	}

}
