class service-percona (
	$master,
	$root_password,
	$cluster_name = $node_role,
	$sst_user = 'sstuser',
	$sst_pass = 's3cretPass'
) {

	# get gpg key
	exec { 'percona-apt-key':
		command => '/usr/bin/apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A',
		creates => '/etc/apt/sources.list.d/percona.list'
	}

	file { '/etc/apt/sources.list.d/percona.list':
		ensure => file,
		content => "deb http://repo.percona.com/apt wheezy main\ndeb-src http://repo.percona.com/apt wheezy main",
		require => Exec['percona-apt-key']
	}

	exec { 'percona-apt-get-update':
		command => '/usr/bin/apt-get update',
		require => File['/etc/apt/sources.list.d/percona.list']
	}

	package { 'percona-xtradb-cluster-56':
		ensure => installed,
		require => Exec['percona-apt-get-update']
	}

	exec { 'percona-root-password':
		command => "/usr/bin/mysqladmin -u root password ${root_password}",
		require => Package['percona-xtradb-cluster-56'],
		creates => '/etc/mysql/root-done'
	}

	file { '/etc/mysql/root-done':
		ensure => file,
		content => 'root pw set',
		require => Exec['percona-root-password']
	}

	# export current ip for cluster management
	@@service-percona::clusterip {$::hostname:
		ip => $::ipaddress_eth1,
		node_number => $node_number,
		node_role => $node_role,
		hostname => $::hostname
	}

	$config_file = '/etc/mysql/my.cnf'
	
	concat { $config_file: }

	concat::fragment { "service-percona::my.cnf.header-${name}":
		target  => $config_file,
		content => template("${module_name}/etc/mysql/my.cnf.header.erb"),
		order   => '01'
	}

	if $master == true {
		concat::fragment { "service-percona::my.cnf.cluster-${name}":
			target  => $config_file,
			content => "# Empty gcomm address is being used when cluster is getting bootstrapped\nwsrep_cluster_address=gcomm://",
			order   => '02'
		}

		exec { 'percona-master-bootstrap':
			command => "/usr/sbin/service mysql stop && /etc/init.d/mysql bootstrap-pxc",
			creates => '/etc/mysql/bootstrapped'
		}

		
		
		$sql = "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 's3cretPass';\nGRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';\nFLUSH PRIVILEGES;"
		exec { 'sst_user':
			command => "/usr/bin/mysql -uroot -p${root_password} -e ${sql}",
			require => Exec['percona-master-bootstrap'],
			creates => '/etc/mysql/bootstrapped'
			#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
			#refreshonly => true,
		}

		file { '/etc/mysql/bootstrapped':
			ensure => file,
			content => 'bootstrapped',
			require => Exec['sst_user']
		}

		#service { 'mysql':
		#	enable => true,
		#	ensure => running
		#}

	} else {
		#fail('wtf, no slave yet')
		concat::fragment { "service-percona::my.cnf.cluster-${name}":
			target  => $config_file,
			content => "# Add gcomm address being used in cluster\nwsrep_cluster_address=gcomm://",
			order   => '02'
		}

		Service-percona::Clusterip <<||>>
		# Empty gcomm address is being used when cluster is getting bootstrapped
		#wsrep_cluster_address=gcomm://

		# Cluster connection URL contains the IPs of node#1, node#2 and node#3
		#wsrep_cluster_address=gcomm://192.168.70.61,192.168.70.62,192.168.70.63


		# gather ips from exported resources
	}


	concat::fragment { "service-percona::my.cnf.footer-${name}":
		target  => $config_file,
		content => template("${module_name}/etc/mysql/my.cnf.footer.erb"),
		order   => '20' # its so high to be able to get a big cluster of 15 nodes. Each node has a order in in cluster.pp
	}



	#apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
	#nano /etc/apt/sources.list.d/percona.list
	#    Content: deb http://repo.percona.com/apt wheezy main
	#             deb-src http://repo.percona.com/apt wheezy main
	#apt-get update
	#apt-get install percona-xtradb-cluster-56
}
