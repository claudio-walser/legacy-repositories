define service-percona::server (
	$bootstrap,
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

	$config_file = '/etc/mysql/my.cnf'
	concat { $config_file: }

	# export current ip for cluster management
	@@service-percona::clusterip {$::hostname:
		ip => $::ipaddress_eth1,
		node_number => $node_number,
		node_role => $node_role,
		hostname => $::hostname
	}

	# write cluster config start
	concat::fragment { "service-percona::my.cnf.header-${name}":
		target  => $config_file,
		content => template("${module_name}/etc/mysql/my.cnf.header.erb"),
		order   => '01'
	}

	# write cluster config address pool
	concat::fragment { "service-percona::my.cnf.cluster-${name}":
		target  => $config_file,
		content => "# Add gcomm address being used in cluster\nwsrep_cluster_address=gcomm://",
		order   => '02'
	}
	
	if $bootstrap == true {
		# bootstrap the cluster on the first node
		exec { 'percona-master-bootstrap':
			command => "/usr/sbin/service mysql stop && /etc/init.d/mysql bootstrap-pxc",
			creates => '/etc/mysql/bootstrapped'
		}

		# create sst user
		$sql = "CREATE USER 'sstuser'@'localhost' IDENTIFIED BY 's3cretPass';\nGRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';\nFLUSH PRIVILEGES;"
		exec { 'sst_user':
			command => "/usr/bin/mysql -uroot -p${root_password} -e ${sql}",
			require => Exec['percona-master-bootstrap'],
			creates => '/etc/mysql/bootstrapped'
			#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
			#refreshonly => true,
		}

		# create file for only bootstrap it once
		file { '/etc/mysql/bootstrapped':
			ensure => file,
			content => 'bootstrapped',
			require => Exec['sst_user']
		}

	} else {
		# gather service ips, which are written to my.cnf in the exported resource
		Service-percona::Clusterip <<||>>
	}

	# write config end
	concat::fragment { "service-percona::my.cnf.footer-${name}":
		target  => $config_file,
		content => template("${module_name}/etc/mysql/my.cnf.footer.erb"),
		order   => '20' # its so high to be able to get a big cluster of 15 nodes. Each node has a order in in cluster.pp
	}

	# restart mysql service to hook into cluster
	exec { "mysql-restart":
		command => '/usr/sbin/service mysql restart',
		require => Concat[$config_file],
		creates => '/etc/mysql/clustered'
			#path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
			#refreshonly => true,
	}

	# create file to not restart mysql on every puppet run
	file { '/etc/mysql/clustered':
		ensure => file,
		content => 'clustered',
		require => Exec['mysql-restart']
	}

}
