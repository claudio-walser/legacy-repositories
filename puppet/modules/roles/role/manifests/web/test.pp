class role::web::test {
	# todo: config in hiera
	service-nginx::vhost{"test.${fqdn}":
		server_name => "test.${fqdn}",
		server_aliases => ["test.${hostname}"],
		root => '/var/www/test',

		proxy_name => "test.${domain}",
		proxy_aliases => ["test"],

		php => true,
		php_root => '/var/www/test',
		git_root => '/var/www/test',
		git => 'http://git-01.development.claudio.dev/claudio.walser/test.git'
	}
}