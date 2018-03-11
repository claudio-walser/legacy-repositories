class service-puppet::master {
	
	# Configure hiera
	file { '/etc/puppet/hiera.yaml':
		ensure => file,
		source => "puppet:///modules/${module_name}/etc/puppet/hiera.yaml",
		owner  => 'puppet',
		group  => 'puppet',
		mode   => '0744'
	}

  class { 'puppetdb::globals':
      version => '2.3.8-1puppetlabs1'
  }

  class { 'puppetdb':
    listen_address     => '10.20.0.2',
    ssl_listen_address => '10.20.0.2'
  }

  class { 'puppetdb::master::config':
    puppetdb_server => 'puppet-master-01.development.claudio.dev'
  }
}
