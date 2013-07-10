class bind9::master {

    # todo
    # - create a template which is filled from network.pp
    file {
        # network.pp to get ip by name
        ["/var/lib/bind/claudio.dev.hosts",
            "/var/cache/bind/claudio.dev.hosts"]:
            ensure  => file,
            mode => 0644,
            owner => bind,
            group => bind,
            source => "puppet:///modules/bind9/master/var/lib/bind/claudio.dev.hosts";
        
        # network.pp to get master ip
        "named.conf.local":
            ensure  => file,
            path => "/etc/bind/named.conf.local",
            mode => 0644,
            owner => bind,
            group => bind,
            source => "puppet:///modules/bind9/master/etc/bind/named.conf.local";
    }

}
