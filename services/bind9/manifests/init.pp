class bind9 {

    package { "bind9": 
        ensure => installed 
    }

    service { "bind9":
        ensure => running
    }

    file { "/var/cache/bind/claudio.dev.hosts":
	    #mode => 440,
	    #owner => root,
	    #group => root,
	    source => "puppet:///services/bind9/claudio.dev.hosts"
	}
}
