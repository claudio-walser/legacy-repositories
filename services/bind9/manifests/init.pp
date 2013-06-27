class bind9 {

    package { "bind9": 
        ensure => installed 
    }

    service { "bind9":
        ensure => running
    }
}
