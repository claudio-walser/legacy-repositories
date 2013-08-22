class service-bind9 {
    # fetch network variables to create zone file
    $externalNameserverIps = $network['externalNameserverIps']

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
        content => template("service-bind9/etc/bind/named.conf.options.erb")
    } ->

    file { "/etc/bind/named.conf.local":
        ensure  => file,
        path => "/etc/bind/named.conf.local",
        mode => 0644,
        owner => bind,
        group => bind,
        content => ''
    } ->

    service { "bind9":
        ensure => running
    }

}
