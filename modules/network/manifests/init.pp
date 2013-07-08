class network {
	
	file { '/tmp/test':
		ensure => 'file',
		content => 'gut'

	}

	create_interfaces_file()


	# todo
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