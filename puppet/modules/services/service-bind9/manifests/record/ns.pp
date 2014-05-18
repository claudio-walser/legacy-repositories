define service-bind9::record::ns (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$ip = $::ipaddress_eth1
) {
	#NS		<%= nameserver %>.<%= @domain %>.
	
	concat::fragment { "service-bind9::record::ns-${name}":
		target  => $hostsfile,
		content => "				NS		${name}.${domain}.",
		order   => '02'
	}
}
