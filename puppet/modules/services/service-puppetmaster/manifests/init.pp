class service-puppetmaster {
	
	package { 'ruby-dev':
		ensure => 'installed'
	} ->

	package { 'librarian-puppet':
	    ensure   => 'installed',
	    provider => 'gem',
	}

}
