class component-network {
	## fetch some important variables
	$hostIp = get_host_ip($network)
	$isDns = is_dns_node($network)
	# overwrite this, even if its a facter value
	$domain = $network['domain']
	$gateway = $network['gateway']
	$netmask = $network['netmask']
	$nameservers = $network['nameservers']
	$members = $network['members']

	$staticEth = $network['staticEth']
	$dynamicEth = $network['dynamicEth']

	$internalNameserverIps = get_internal_nameserver_ips($network)
	$externalNameserverIps = $network['externalNameserverIps']

	## create the resolv conf file with the given data
	file { '/etc/resolv.conf':
		ensure  => file,
		mode => 0644,
		owner => 'root',
		group => 'root',
		content => template("component-network/etc/resolv.conf.erb")
	}

	## create interfaces with the given data
	file { '/etc/network/interfaces':
		ensure  => file,
		mode => 0644,
		owner => 'root',
		group => 'root',
		content => template("component-network/etc/network/interfaces.erb")
	}

	## ensure dhcp is not updating anything
	file { '/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate':
		ensure  => file,
		mode => 0644,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/component-network/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate"
	}







	## some tests
	#file { '/tmp/test':
	#	ensure => 'file',
	#	content => 'gut'
	#}

	# fetch network info and put them into a template
	# todo rename the function since its not creating anyting on the client
	#create_interfaces_file($network)




	# todo
	# - write a module for automated network config
	#  - make sure dns server became special network config, some working backups ar in the appliance folder to have a look /etc/(resolv.conf|network/interfaces)
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
	#		nameserver 195.186.1.111 ## get external nameserver from network.pp only in dns roles

	#  - write script to deny overwriting the resolv.conf in /etc/dhcp/dhclient-enter-hooks.d/nodnsupdate
	#		#!/bin/sh
	#		make_resolv_conf(){
	#			:
	#		}

}