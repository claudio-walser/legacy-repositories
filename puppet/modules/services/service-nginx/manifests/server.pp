define service-nginx::server {

	class { '::nginx': }

	exec { 'mkdir -p /etc/nginx/fastcgi_params.d/':
		command => "mkdir -p /etc/nginx/fastcgi_params.d/",
		path => '/bin',
		creates => '/etc/nginx/fastcgi_params.d'
	}

   	file { '/etc/nginx/fastcgi_params.d/web':
        ensure => 'file',
        source => "puppet:///modules/service-nginx/etc/nginx/fastcgi_params.d/web",
        require => Exec['mkdir -p /etc/nginx/fastcgi_params.d/']
    }

    file { '/var/www/default':
        ensure => 'directory',
        owner => 'www-data',
        group => 'www-data',
        mode => 0755
    }

	# default host name
	::nginx::resource::vhost { $fqdn:
	  server_name => [$::fqdn],
	  ensure   => present,
	  www_root => '/var/www/default',
	  require => File['/var/www/default']
	}

	::nginx::resource::location { "${fqdn} ~ .php$":
	  location => '~ .php$',
	  ensure   => present,
	  vhost => $fqdn,
	  fastcgi => '127.0.0.1:9001',
	  fastcgi_params => '/etc/nginx/fastcgi_params.d/web'
	}

}
