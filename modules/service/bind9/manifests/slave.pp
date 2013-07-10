class bind9::slave {
    
    file { "named.conf.local":
        ensure  => file,
        path => "/etc/bind/named.conf.local",
        mode => 0644,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/slave/etc/bind/named.conf.local"
    }

}
