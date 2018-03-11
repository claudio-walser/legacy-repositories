define service-nginx::vhost (
	$server_name = $fqdn,
	$server_aliases = [],
	$proxy_name = undef,
	$proxy_aliases = [],
	$root = undef,
	$php = false,
	$php_root = undef,
	$entry_on_default_host = false
) {
	
	# make sure server root exists as directory
	if $root != undef {
		exec {"mkdir -p ${root} - root":
			command => "mkdir -p ${root}",
			path => "/bin/"
		}
	}

	# gather vhost name and all possible aliases
	$server_names_tmp = concat([$server_name], $server_aliases)
	if $proxy_name != undef {
		$proxy_names_tmp = concat([$proxy_name], $proxy_aliases)
		$server_names = concat($server_names_tmp, $proxy_names_tmp)
	} else {
		$server_names = $server_names_tmp
	}

	$server_hashes = create_cname_hash($server_names)

	if is_hash($server_hashes) {
		#export dns cnames, this is just a wrapper for create_resources and export resources
		create_resources( 'service-nginx::cname', $server_hashes, {
			host => $::hostname
		})
	}
	

	::nginx::resource::vhost { $server_name:
		server_name => $server_names,
		ensure   => present,
		www_root => $root
	}	

	# php support for this app
	if str2bool("$php") {
		$fastcgi_default_include = 'include fastcgi_params;'
		if $php_root != undef {
			$php_root_execution = $php_root
		} else {
			$php_root_execution = $root
		}

		file { "/etc/nginx/fastcgi_params.d/${proxy_name}":
			ensure => 'file',
			content => template("service-nginx/etc/nginx/fastcgi_params.d/params_template.erb")
		}


		::nginx::resource::location { "${server_name} ~ .php$":
		  location => '~ .php$',
		  ensure => present,
		  vhost => $server_name,
		  fastcgi => '127.0.0.1:9001',
		  fastcgi_params => "/etc/nginx/fastcgi_params.d/${proxy_name}"
		}
		
	}

	if $entry_on_default_host == true {
		$defaultIndexFile = '/var/www/default/index.html'
		concat::fragment { "${defaultIndexFile}.entry-${server_name}":
			target  => $defaultIndexFile,
			content => "<li><a href=\"http://${server_name}\">${server_name}</a></li>",
			order   => '02'
		}
	
	}

	#if $proxy_name != undef {
		# do load balancing on webproxy-xx
		#@@service-webproxy::member { "${proxy_name}-${fqdn}" :
		#	server_name => $proxy_name,
		#	server_aliases => $proxy_aliases,
		#	member_name => $fqdn
		#}

	#}

}
