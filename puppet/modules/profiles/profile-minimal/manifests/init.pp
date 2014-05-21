class profile-minimal (
	$users = []
) {
	
	# some default packages
	package { [
		'bash-completion',
		'sudo',
		'rsync'
	]:
		ensure => installed
	}

	# export dns member
	@@service-bind9::record::a{$::hostname:
		ip => $::ipaddress_eth1
	}

	# import resolv.conf from dns
	Service-bind9::Resolvconf <<||>>

	#fail($node_number)

	# take care dhcp client is not changing resolv.conf
	file { '/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate':
		ensure  => file,
		mode => 0644,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/${module_name}/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate"
	}

	class { ::profile-minimal::mounts: }	
	class { ::profile-minimal::motd: }

	# create users
	if is_hash($users) {
		create_resources( 'profile-minimal::user', $users)
	}
}
