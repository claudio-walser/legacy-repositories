define service-nginx::php {

	include ::php::fpm::daemon
	::php::fpm::conf { "${::fqdn}":
		listen  => "127.0.0.1:9001",
		listen_allowed_clients => "127.0.0.1",
		user => 'www-data'
	}

}
