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

	
	#class { ::profile-minimal::user:
	#	$username => 'claudio',
	#	ensure => 'present',
	#	groups => 'sudo',
	#	# limitation: just one ssh key per user yet
	#	ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDr7a2SJhk6m+dVl37qGjyAv6NeZY3Qk/WKdKRABhK9PM3tixbXvsuc+yxi0+vJ057QdfjQAcgaszNOiedvqtT5TOMlKnd0LaLxMWnQ0jVqsqbPyv8BdUtYa91VAvwxghcTa6RgoyQN8QO6b5GBtUewDjbaIa4aVyKjaUF8Ffq2SoamK/WqJPQXgnn0i96JlaXCoS5TS8MOQbiffmC9PhrqPzXAHgPcvfsNjk85UyL4w2r8Jwn37qrpRZDLk3ggey64haDKmPESNNia6OyqarkWcNsrLxzkUfdjVXzDPYmYkjN4bbCH88rkZZH6KnEBdcvdCQsQWrdm6xjuhs7uUZ7n claudio@dev.local',
	#	no_passwd => true,
	#	shell => '/bin/bash'
	#}

	# create users
	if is_hash($users) {
		create_resources( 'profile-minimal::user', $users)
	}
}
