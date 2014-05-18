class service-puppet::master {
	
	# Configure puppetdb and its underlying database
	class { 'puppetdb': 
		listen_address => $::fqdn
	}
	
	# Configure the puppet master to use puppetdb
	#class { 'puppetdb::master::config': }
	class { 'puppetdb::master::config':	}

}
