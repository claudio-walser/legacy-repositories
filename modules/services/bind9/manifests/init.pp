class bind9 {
    
    # fetch network variables to create zone file
    $domain = $network['domain']
    $internalNameservers = $network['internalNameservers']
    $externalNameserverIps = $network['externalNameserverIps']
    $members = $network['members']
    $staticEth = $network['staticEth'] # needed for fetching ips for the A Record
    $mainNameserver = $internalNameservers[0]
    $mainNameserverIp = $members[$mainNameserver][$staticEth]
    $mainServerIp = $network['mainServerIp']

    # fetch info for etc/bind/named.conf.local
    if $hostname == 'dns-01' {
        $type = 'master'
        # put zone file for master
        file {
        # network.pp to get ip by name
        ["/var/lib/bind/$domain.hosts",
         "/var/cache/bind/$domain.hosts"]:
            ensure  => file,
            mode => 0644,
            owner => bind,
            group => bind,
            require  => Package["bind9"],
            notify  => Service["bind9"],
            content => template("bind9/var/lib/bind/$domain.hosts.erb")
        }
    } else {
        $type = 'slave'
    }


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
        content => template("bind9/etc/bind/named.conf.options.erb")
    } ->

    file { "named.conf.local":
        ensure  => file,
        path => "/etc/bind/named.conf.local",
        mode => 0644,
        owner => bind,
        group => bind,
        content => template("bind9/etc/bind/named.conf.local.erb")
    } ->

    service { "bind9":
        ensure => running
    }

}
