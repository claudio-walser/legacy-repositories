class bind9::master {
    
    file { "claudio.dev.hosts":
        ensure  => file,
        path => "/var/lib/bind/claudio.dev.hosts",
        mode => 0644
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts"
    }

    file { "named.conf.local":
        ensure  => file,
        path => "/etc/bind/named.conf.local",
        mode => 0644,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/etc/bind/named.conf.local"
    }

}
