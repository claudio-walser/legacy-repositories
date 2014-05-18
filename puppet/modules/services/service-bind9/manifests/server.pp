class service-bind9::server (
	$hostsfile = "/var/lib/bind/$::domain.hosts",
	$ip = $::ipaddress_eth1,
	$domain = $::domain,
	$hostname = $::hostname,
	$mailAddress = 'root@localhost',
	$externalNameservers = [
		'8.8.8.8',
		'195.186.1.111',
		'195.186.4.111'
	]
) {


	# install packages
	package { [
		'bind9',
		'dnsutils'
	]:
		ensure => installed
	}

	# export NS entries
	@@service-bind9::record::ns{$::hostname: }

	if $node_number == 1 {
		$type = 'master'

		# export master ip for slave zones
		# export dns member
		@@service-bind9::slave{$::hostname:
			master_ip => $::ipaddress_eth1
		}
		
		file { "/etc/bind/named.conf.d/$domain.conf":
			ensure  => file,
			path => "/etc/bind/named.conf.d/$domain.conf",
			mode => 0644,
			owner => bind,
			group => bind,
			content => template("${module_name}/etc/bind/named.conf.d/zone-config.erb"),
			require => File['/etc/bind/named.conf.d']
		}

		# fetch all exported resources and build zone file
		file { "/var/lib/bind":
			ensure => 'directory'
		}

		concat { $hostsfile:
			require => File['/var/lib/bind'],
			ensure_newline => true,
			notify  => Service['bind9']
		}

		concat::fragment { "${hostsfile}.head":
			target  => $hostsfile,
			content => template("${module_name}/var/lib/hosts.head.erb"),
			order   => '01'
		}

		Service-bind9::Record::Ns <<||>>
		
		concat::fragment { "service-bind9::record::ns-${name}":
			target  => $hostsfile,
			content => "\$ORIGIN $domain.",
			order   => '03'
		}

		Service-bind9::Record::A <<||>>
		Service-bind9::Record::CNAME <<||>>
	} else {
		Service-bind9::Slave <<||>>
	}


	## zone config file
	file { '/etc/bind/named.conf.d':
		ensure => "directory",
		owner  => "bind",
		group  => "bind",
		mode   => 755,
		require  => Package["bind9"]
	}

	# configuration files
	# todo	slaveNameserverIps -> maybe read from puppetdb
	file { "/etc/bind/named.conf.options":
		ensure  => file,
		mode => 0644,
		owner => bind,
		group => bind,
		content => template("${module_name}/etc/bind/named.conf.options.erb")
	}

	file { "/etc/bind/named.conf.local":
		ensure  => file,
		path => "/etc/bind/named.conf.local",
		mode => 0644,
		owner => bind,
		group => bind,
		content => '',
		require => File ["/etc/bind/named.conf.options"]
	}

	## add the named.conf.d file to named.conf.local
	exec { 'bind-named-conf-d':
		command => "echo 'include \"/etc/bind/named.conf.d/$domain.conf\";' >> /etc/bind/named.conf.local",
		path => '/bin',
		require => File["/etc/bind/named.conf.local", "/etc/bind/named.conf.d/$domain.conf"]
	}
	
	service {'bind9':
		ensure => 'running',
		hasstatus => true,
		enable => true,
		hasrestart => true,
		require => Exec['bind-named-conf-d']
	}

}
