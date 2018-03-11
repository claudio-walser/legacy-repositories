class service-haproxy {

	package { "haproxy":
		ensure => 'installed'
	}


	file { "/etc/haproxy/haproxy.cfg":
		ensure => file,
		source => "puppet:///modules/service-haproxy/etc/haproxy/haproxy.cfg",
		require => Package['haproxy']
	}

}
