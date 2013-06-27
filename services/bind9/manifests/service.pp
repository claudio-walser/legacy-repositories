class bind9::service {
    
    service { "bind9":
        ensure => running
    }

}
