class bind9::slave {
    
    file { "named.conf.local":
        path => "/etc/bind/named.conf.local",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/slave/etc/bind/named.conf.local"
    }

}
