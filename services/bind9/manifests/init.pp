class bind9 {
    
    package { "bind9": 
        ensure => installed 
    }
    
    package { "dnsutils": 
        ensure => installed 
    }

}
