class bind9 {
    file { "claudio.dev.hosts":
        path => "/var/lib/bind/claudio.dev.hosts",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts"
    }

    file { "named.conf.local":
        path => "/etc/bind/named.conf.local",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/etc/bind/named.conf.local"
    }

    package { "bind9": 
        ensure => installed 
    }
    
    package { "dnsutils": 
        ensure => installed 
    }

    service { "bind9":
        ensure => running
    }

}
