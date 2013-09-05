# this files is taken to create etc/resolv.conf, etc/network/interfaces and the claudio.dev.hosts zone file on dns boxes as well
$network = {
	'domain' => 'claudio.dev',
	'mainServerIp' => '10.20.1.4', # gitlab server right now, going to be the development server with my sandboxes later
	'dynamicEth' => 'eth0',

	'defaultIp' => '10.20.1.250',
	'staticEth' => 'eth1',
	'gateway' => '10.20.1.1',
	'netmask' => '255.255.255.0',
	
	'externalNameserverIps' => [
	 	# dev.ch
	 	'10.20.0.41',
	 	'10.20.0.42',
	 	#sfdrs.local
	 	'10.131.129.10',
	 	'10.157.129.10',
	 	#bluewin.ch
	 	'195.186.1.111',
	 	'195.186.4.111'
	 ],

	'internalNameservers' => [
		'dns-01',
		'dns-02'
	 ],
	
	'members' => {
		# default box
		'core' => {
			'eth1' => '10.20.1.250',
			'eth0' => 'dhcp'
		},

		#puppet masters
		'puppet-master-01' => {
			'eth1' => '10.20.1.2',
			'eth0' => 'dhcp'
		},

		#build host
		'build-01' => {
			'eth1' => '10.20.1.3',
			'eth0' => 'dhcp'
		},

		#gitlab servers
		'git-01' => {
			'eth1' => '10.20.1.4',
			'eth0' => 'dhcp'
		},

		#dns servers
		'dns-01' => {
			'eth1' => '10.20.1.8',
			'eth0' => 'dhcp'
		},
		'dns-02' => {
			'eth1' => '10.20.1.9',
			'eth0' => 'dhcp'
		},

		# mysql cluster
		'db-proxy-01' => {
			'eth1' => '10.20.1.10',
			'eth0' => 'dhcp'
		},
		'db-proxy-02' => {
			'eth1' => '10.20.1.11',
			'eth0' => 'dhcp'
		},
		'db-master-01' => {
			'eth1' => '10.20.1.12',
			'eth0' => 'dhcp'
		},
		'db-master-02' => {
			'eth1' => '10.20.1.13',
			'eth0' => 'dhcp'
		},
		'db-slave-01' => {
			'eth1' => '10.20.1.14',
			'eth0' => 'dhcp'
		},
		'db-slave-02' => {
			'eth1' => '10.20.1.15',
			'eth0' => 'dhcp'
		}
	}

}






