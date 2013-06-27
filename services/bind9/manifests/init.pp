class bind9 {

	file { "/var/cache/bind/claudio.dev.hosts":
	    #mode => 440,
	    #owner => root,
	    #group => root,
	    source => "puppet:///modules/bind9/claudio.dev.hosts"
	}

    package { "bind9": 
        ensure => installed 
    }

    service { "bind9":
        ensure => running
    }

    package { "nsupdate": 
        ensure => installed 
    }


}
