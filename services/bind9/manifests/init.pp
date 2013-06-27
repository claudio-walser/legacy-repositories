class bind9 {

    package { "bind9": 
        ensure => installed 
    }

    service { "bind9":
        ensure => running
    }

    file { "/var/cache/bind":
	    mode => 440,
	    owner => bind,
	    group => bind,
	    source => "puppet:///services/bind9/claudio.dev.zone"
	}
}
