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

	package { 'ruby-hiera-puppet':
	    ensure   => 'installed'
	} ->

	package { 'librarian-puppet':
	    ensure   => 'installed',
	    provider => 'gem'
	} ->

	exec { 'librarian-puppet-install':
		command => "bash /etc/puppet/rsync.sh",
		path => '/bin'
	} ->

	# install puppetdb
	package { 'puppetdb':
	    ensure   => 'installed'
	}
}
