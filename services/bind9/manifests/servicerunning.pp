class bind9::servicerunning {
    
    service { "bind9":
        ensure => running
    }

}
