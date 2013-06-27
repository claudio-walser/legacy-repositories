class common {
	## common users
	##include user::virtual

	file {'motd':
		ensure  => file,
		path    => '/etc/motd',
		mode    => 0644,
		content =>

		"
		This is a Test-Environment
		Operating System: ${operatingsystem}
		Operating System Release: ${operatingsystemrelease}
		Name: ${fqdn}
		IPAdresses
			ETH-0: ${ipadress_eth0}
			ETH-1: ${ipadress_eth1}
		Puppetversion: ${puppetversion}
		"
	}



    package { "ssh": 
        ensure => installed 
    }

    service { "ssh":
        ensure => running
    }
}
