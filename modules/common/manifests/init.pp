class common {
	## common users
	##include user::virtual

	file {'motd':
		ensure  => file,
		path	=> '/etc/motd',
		mode	=> 0644,
		content =>
"
Puppet provisioned machine
Operating System: ${operatingsystem} ${operatingsystemrelease}
Name: ${fqdn}
ETH-0: ${ipaddress_eth0}
ETH-1: ${ipaddress_eth1}
"
	}



	package {"openssh-server": 
		ensure => installed 
	} ->
	service { "ssh":
		ensure => running
	}

	#todo
	# - ensure root user and group is present
	# - ensure claudio is present and in sudoers
	# - ensure only defined users can sudo
	# - ensure ssh root login disabled
	# - esnure fail2ban is configured and running
	# - ensure failed logins are reported somewhere
	# - write a module for automated network config
	#  - there is a need for /etc/network/interfaces
	#		# UNCONFIGURED INTERFACES
	#		# remove the above line if you edit this file

	#		auto lo
	#		iface lo inet loopback

	#		auto eth0
	#		iface eth0 inet dhcp

	#		auto eth1
	#		iface eth1 inet static
	#		    address 10.20.1.250 # get ip for the name from network.pp | this is the core.claudio.dev's ip
	#		    netmask 255.255.255.0 # get netmask from network.pp
	#		    gateway 10.20.1.1 # get gateway from network.pp
	#		    dns-nameservers 10.20.1.3 10.20.1.4 195.186.1.111 # get nameservers from network.pp

	#		#auto eth0
	#		#iface eth0 inet dhcp

	#  - write /etc/resolv.conf
	#		search claudio.dev # get domain from network.pp
	#		nameserver 10.20.1.3 # get nameserver from network.pp
	#		nameserver 10.20.1.4 # get nameserver from network.pp
	#		nameserver 195.186.1.111 ## get external nameserver from network.pp

	#  - write script to deny overwriting the resolv.conf in /etc/dhcp/dhclient-enter-hooks.d/nodnsupdate
	#		#!/bin/sh
	#		make_resolv_conf(){
	#			:
	#		}

}
