class service-bind9 {
    # fetch network variables to create conf file
    $externalNameserverIps = $network['externalNameserverIps']
    
    $internalNameservers = $network['internalNameservers']
    $members = $network['members']
    $staticEth = $network['staticEth']

    $masterNameserver = $internalNameservers[0]
    $masterNameserverIp = $members[$masterNameserver][$staticEth]
    
    $slaveNameserver = $internalNameservers[1]
    $slaveNameserverIp = $members[$slaveNameserver][$staticEth]

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

    exec { 'service-bind9::start-service':
        command => "service bind9 restart",
        path => '/usr/sbin'
    }

}
