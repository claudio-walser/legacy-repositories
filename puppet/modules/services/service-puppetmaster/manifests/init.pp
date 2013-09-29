class service-puppetmaster {
	
	package { 'ruby-dev':
		ensure => 'installed'
	} ->

	package { 'hiera-puppet':
	    ensure   => 'installed'
	} ->

	package { 'librarian-puppet':
	    ensure   => 'installed',
	    provider => 'gem'
	}

}
