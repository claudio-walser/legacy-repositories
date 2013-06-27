class bind9::ensureServiceRunning {
    
    service { "bind9":
        ensure => running
    }

}
