class service-puppetmaster {
	
	file { '/etc/puppet/rsync.sh':
		ensure  => file,
		mode => 0775,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/service-puppetmaster/etc/puppet/rsync.sh"
	} ->

	file { '/etc/apt/sources.list.d/puppetlabs.list':
		ensure  => file,
		mode => 0775,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/service-puppetmaster/etc/apt/sources.list.d/puppetlabs.list"
	} ->
	
	exec { 'apt-update-puppetlabs':
		command => "apt-get update",
		path => '/usr/bin'
	} ->

	package { 'git':
		ensure => 'installed'
	} ->

	package { 'puppetmaster':
		ensure => 'installed'
	} ->

	package { 'ruby-dev':
		ensure => 'installed'
	} ->


	
	exec { 'apt-get-install-hiera-puppet':
		command => 'apt-get --yes --force-yes install hiera-puppet; exit 0;',
		path => '/usr/bin'
	} ->

	package { 'librarian-puppet':
	    ensure   => 'installed',
	    provider => 'gem'
	} ->

	exec { 'librarian-puppet-install':
		command => "bash /etc/puppet/rsync.sh",
		path => '/bin'

	} ->

	exec { 'apt-get-install-puppetdb':
		command => 'apt-get --yes --force-yes install puppetdb puppetdb-terminus; exit 0;',
		path => '/usr/bin'
	} ->

	# use puppetdb on the same node as the puppetmaster
	class { 'puppetdb':
		listen_address => '0.0.0.0',
		ssl_listen_address => '0.0.0.0',
		java_args => {
			'-Xmx' => '512m',
			'-Xms' => '256m'
		}
	}

	class { 'puppetdb::master::config':
		puppetdb_server => $fqdn
	}


}
