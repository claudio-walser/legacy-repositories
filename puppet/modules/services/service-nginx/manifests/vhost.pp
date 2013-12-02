define service-nginx::vhost (
	$server_name = $fqdn,
	$server_aliases = [],
	$proxy_name = undef,
	$proxy_aliases = [],
	$root = undef,
	$php = false,
	$php_root = undef,
	$git = undef,
	$git_root = undef
) {

	# make sure server root exists as directory
	if $root != undef {
		exec {"mkdir -p ${root} - root":
			command => "mkdir -p ${root}",
			path => "/bin/"
		}
	}

	if $git_root != undef {
		exec {"mkdir -p ${git_root} - git_root":
			command => "mkdir -p ${git_root}",
			path => "/bin/"
		}
	}
	
	# check params properly
	if $git != undef {
		# if no root defined we dont have a target to checkout
		if $git_root == undef {
			error('You cannot pass git path without a root to checkout into.')
		}

		# git checkout with module
		vcsrepo { $root:
			ensure => present,
			provider => git,
			source => $git,
			require => Package ['git']
		}
	}

	# default host name
	#$server_names = merge
	$server_names_tmp = concat([$server_name], $server_aliases)
	if $proxy_name != undef {
		$proxy_names_tmp = concat([$proxy_name], $proxy_aliases)
		$server_names = concat($server_names_tmp, $proxy_names_tmp)
	} else {
		$server_names = $server_names_tmp
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

	if $proxy_name != undef {
		# do load balancing on webproxy-xx
		@@service-webproxy::member { "${proxy_name}-${fqdn}" :
			server_name => $proxy_name,
			server_aliases => $proxy_aliases,
			member_name => $fqdn
		}

	}

	#class { '::nginx': }

	#exec { 'mkdir -p /etc/nginx/fastcgi_params.d/':
	#	command => "mkdir -p /etc/nginx/fastcgi_params.d/",
	#	path => '/bin',
	#	creates => '/etc/nginx/fastcgi_params.d'
	#} ->

   	#file { '/etc/nginx/fastcgi_params.d/web':
    #    ensure => 'file',
    #    source => "puppet:///modules/service-nginx/etc/nginx/fastcgi_params.d/web"
    #}

	# default host name
	#::nginx::resource::vhost { $fqdn:
	#  server_name => [$fqdn, 'web.development.claudio.dev'],
	#  ensure   => present,
	#  www_root => '/var/www'
	#}

	#::nginx::resource::location { '~ .php$':
	#  ensure   => present,
	#  vhost => $fqdn,
	#  fastcgi => '127.0.0.1:9001',
	#  fastcgi_params => '/etc/nginx/fastcgi_params.d/web'
	#}

}
