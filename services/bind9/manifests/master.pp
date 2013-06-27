class bind9::master {
    
    file { "claudio.dev.hosts":
        path => "/var/lib/bind/",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts"
    }

}
