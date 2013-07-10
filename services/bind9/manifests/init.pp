class bind9 {
    
    package { "bind9": 
        ensure => installed 
    } ->
    
    package { "dnsutils": 
        ensure => installed 
    } ->

    file { "/etc/bind/named.conf.options":
    	ensure  => file,
        mode => 0644,
        owner => bind,
        group => bind,
        source => "puppet:///modules/bind9/general/etc/bind/named.conf.options"
    }

}
