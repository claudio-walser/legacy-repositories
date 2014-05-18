class profile-minimal {
	
	# some default packages
	package { [
		'bash-completion',
		'sudo'
	]:
		ensure => installed
	}

	# export dns member
	@@service-bind9::record::a{$::hostname:
		ip => $::ipaddress_eth1
	}

}
