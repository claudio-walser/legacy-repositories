class role::web::spaf {
	# todo: config in hiera
	service-nginx::vhost{"spaf.${fqdn}":
		server_name => "spaf.${fqdn}",
		server_aliases => ["spaf.${hostname}"],
		proxy_name => "spaf.${domain}",
		proxy_aliases => ["spaf"],

		#balanced_name => "spaf.${domain}",
		#server_id => "spaf.${fqdn}",
		#server_names => ["spaf.${domain}", "spaf", "spaf.${fqdn}"],
		php => true,
		php_root => '/var/www/spaf',
		root => '/var/www/spaf',
		git_root => '/var/www/spaf',
		git => 'http://git-01.development.claudio.dev/claudio.walser/spaf.git'
	}
}