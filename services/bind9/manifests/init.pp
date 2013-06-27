class bind9 {
    file { "claudio.dev.hosts":
        path => "/var/lib/bind/claudio.dev.hosts",
        mode => 655,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts"
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
