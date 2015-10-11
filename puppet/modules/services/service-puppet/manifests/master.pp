class service-puppet::master {
	
	# Configure hiera
	file { '/etc/puppet/hiera.yaml':
		ensure => file,
		source => "puppet:///modules/${module_name}/etc/puppet/hiera.yaml",
		owner  => 'puppet',
		group  => 'puppet',
		mode   => '0744'
	}


	# Configure puppetdb and its underlying database
	class { 'puppetdb': 
		listen_address => '0.0.0.0',
		disable_ssl => true
	}
	
	# Configure the puppet master to use puppetdb
	#class { 'puppetdb::master::config': }
	class { 'puppetdb::master::config':	}

}
