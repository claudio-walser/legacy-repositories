class bind9::master {
    
    file { "claudio.dev.hosts":
        path => "/var/lib/bind/claudio.dev.hosts",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts",
        replace => true
    }

    file { "named.conf.local":
        path => "/etc/bind/named.conf.local",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/etc/bind/named.conf.local",
        replace => true
    }

}
