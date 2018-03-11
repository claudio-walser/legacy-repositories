define service-webproxy::member (
	$server_name = $fqdn,
	$server_aliases = [$fqdn],
	$member_name = $fqdn
) {

	$clusterName = "${server_name}-cluster"
	# define vhost if not happen yet
	if !defined(Nginx::Resource::Vhost[$server_name]) {
		#$server_names = concat([$server_name], $server_aliases)
		::nginx::resource::vhost { $server_name:
			server_name => [$server_name],
			ensure   => present,
			proxy => "http://${clusterName}"
		}

		# to lazy to check on the fragment itself, they have to be defined once as well
		concat{ "/etc/nginx/conf.d/${clusterName}.conf":
			owner => 'www-data',
			group => 'www-data',
			mode  => '0644',
		}

		concat::fragment { "/etc/nginx/conf.d/${clusterName}.conf-start":
			order => "10-${clusterName}-01",
			ensure => $ensure,
			target => "/etc/nginx/conf.d/${clusterName}.conf",
			content => "upstream ${clusterName} {\n"
		}

		concat::fragment { "/etc/nginx/conf.d/${clusterName}.conf-end":
			order => "30-${clusterName}-01",
			ensure => $ensure,
			target => "/etc/nginx/conf.d/${clusterName}.conf",
			content => '}'
		}

	}

	# concat all upstream members
	concat::fragment { "/etc/nginx/conf.d/${clusterName}.conf-member-${$member_name}":
		order => "20-${clusterName}-01",
		ensure => $ensure,
		target => "/etc/nginx/conf.d/${clusterName}.conf",
		content => "	server ${$member_name};\n"
	}

}
