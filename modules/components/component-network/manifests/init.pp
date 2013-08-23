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
	} ->

	## ifdown force the static one
	#exec { 'ifdown-static':
	#	command => "ifdown --force $staticEth",
	#	path => '/sbin'
	#} ->

	## ifup force the static one
	exec { 'ifup-static':
		command => "ifup --force $staticEth",
		path => '/sbin'
	}

	## ensure dhcp is not updating anything
	file { '/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate':
		ensure  => file,
		mode => 0644,
		owner => 'root',
		group => 'root',
		source => "puppet:///modules/component-network/etc/dhcp/dhclient-enter-hooks.d/nodnsupdate"
	}

	# todo
	# Make sure about ifdown/ifup in case of static ip change

}