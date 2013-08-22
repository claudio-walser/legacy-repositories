class data-bind::claudio-dev { 
    # fetch some data
    $domain = $network['domain']
    $internalNameservers = $network['internalNameservers']
    $members = $network['members']
    $staticEth = $network['staticEth'] # needed for fetching ips for the A Record
    $mainNameserver = $internalNameservers[0]
    $mainNameserverIp = $members[$mainNameserver][$staticEth]
    $mainServerIp = $network['mainServerIp']

    # fetch info for etc/bind/named.conf.d/domain.conf
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
            content => template("data-bind/var/lib/bind/$domain.hosts.erb")
        }
    } else {
        $type = 'slave'
    }

    ## zone config file
    file { "/etc/bind/named.conf.d/$domain.conf":
        ensure  => file,
        path => "/etc/bind/named.conf.d/$domain.conf",
        mode => 0644,
        owner => bind,
        group => bind,
        content => template("data-bind/etc/bind/named.conf.d/zone-config.erb")
    } ->
    ## add the named.conf.d file to named.conf.local
	exec { 'bind-named-conf-d':
		command => "echo 'include \"/etc/bind/named.conf.d/$domain.conf\";' >> /etc/bind/named.conf.local",
		path => '/bin',
		require => File["/etc/bind/named.conf.local"]
	}



}
