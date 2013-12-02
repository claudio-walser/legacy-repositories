class role::web::phpdocumentor {
	# todo: config in hiera
	service-nginx::vhost{"phpdocumentor.${fqdn}":
		server_name => "phpdocumentor.${fqdn}",
		server_aliases => ["phpdocumentor.${hostname}"],
		proxy_name => "phpdocumentor.${domain}",
		proxy_aliases => ["phpdocumentor"],

		php => true,
		php_root => '/var/www/phpdocumentor',
		git_root => '/var/www/phpdocumentor',
		root => '/var/www/phpdocumentor/www',
		git => 'http://git-01.development.claudio.dev/claudio.walser/phpdocumentor.git'
	}
}