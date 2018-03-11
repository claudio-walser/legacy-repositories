define service-bind9::slave (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$master_ip
) {

	$type = 'slave'
	
	file { "/etc/bind/named.conf.d/$domain.conf":
		ensure  => file,
		path => "/etc/bind/named.conf.d/$domain.conf",
		mode => 0644,
		owner => bind,
		group => bind,
		content => template("${module_name}/etc/bind/named.conf.d/zone-config.erb"),
		require => File['/etc/bind/named.conf.d']
	}
}
