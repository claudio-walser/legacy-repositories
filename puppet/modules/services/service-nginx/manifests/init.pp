class service-nginx (
	$git = false
) {

	# php support for this app
	if str2bool("$git") {
		package {'git':
			ensure => 'installed'
		}
	}	

	class { '::nginx': }

	exec { 'mkdir -p /etc/nginx/fastcgi_params.d/':
		command => "mkdir -p /etc/nginx/fastcgi_params.d/",
		path => '/bin',
		creates => '/etc/nginx/fastcgi_params.d'
	} ->

   	file { '/etc/nginx/fastcgi_params.d/web':
        ensure => 'file',
        source => "puppet:///modules/service-nginx/etc/nginx/fastcgi_params.d/web"
    }

	# default host name
	::nginx::resource::vhost { $fqdn:
	  server_name => [$fqdn, 'web.development.claudio.dev'],
	  ensure   => present,
	  www_root => '/var/www'
	}

	::nginx::resource::location { "${fqdn} ~ .php$":
	  location => '~ .php$',
	  ensure   => present,
	  vhost => $fqdn,
	  fastcgi => '127.0.0.1:9001',
	  fastcgi_params => '/etc/nginx/fastcgi_params.d/web'
	}

}
