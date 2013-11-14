# this files is taken to create etc/resolv.conf, etc/network/interfaces and the claudio.dev.hosts zone file on dns boxes as well
$network = {
	'domain' => 'development.claudio.dev',
	'mainServerIp' => '10.20.1.4', # gitlab server right now, going to be the development server with my sandboxes later
	'dynamicEth' => 'eth0',

	'defaultIp' => '10.20.1.250',
	'staticEth' => 'eth1',
	'netmask' => '255.255.255.0',
	
	'externalNameserverIps' => [
	 	#bluewin.ch
	 	'195.186.1.111',
	 	'195.186.4.111'
	 ],

	'internalNameservers' => [
		'dns-01',
		'dns-02'
	 ],
	
	'members' => {

		# default box if unknown
		'core-01' => {
			'eth1' => '10.20.1.250',
			'eth0' => 'dhcp'
		},

		#puppet master
		'puppet-master-01' => {
			'eth1' => '10.20.1.2',
			'eth0' => 'dhcp'
		},

		#build host
		'build-01' => {
			'eth1' => '10.20.1.3',
			'eth0' => 'dhcp'
		},

		#gitlab server
		'git-01' => {
			'eth1' => '10.20.1.4',
			'eth0' => 'dhcp'
		},
		
		# wiki host
		'wiki-01' => {
			'eth1' => '10.20.1.5',
			'eth0' => 'dhcp'
		},
		# ci host
		'jenkins-01' => {
			'eth1' => '10.20.1.6',
			'eth0' => 'dhcp'
		},
		# monitor host
		'monitor-01' => {
			'eth1' => '10.20.1.7',
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

		# mysql cluster .10 loadbalanced
		# proxies, forwarding reading queries to the slaves and writing queries to the masters
		'db-proxy-01' => {
			'eth1' => '10.20.1.11',
			'eth0' => 'dhcp'
		},
		'db-proxy-02' => {
			'eth1' => '10.20.1.12',
			'eth0' => 'dhcp'
		},
		#masters
		'db-master-01' => {
			'eth1' => '10.20.1.13',
			'eth0' => 'dhcp'
		},
		'db-master-02' => {
			'eth1' => '10.20.1.13',
			'eth0' => 'dhcp'
		},
		# slaves
		'db-slave-01' => {
			'eth1' => '10.20.1.14',
			'eth0' => 'dhcp'
		},
		'db-slave-02' => {
			'eth1' => '10.20.1.15',
			'eth0' => 'dhcp'
		}, 

		# php-fpm cluster  .20 loadbalanced
		'php-01' => {
			'eth1' => '10.20.1.21',
			'eth0' => 'dhcp'
		}, 
		'php-02' => {
			'eth1' => '10.20.1.22',
			'eth0' => 'dhcp'
		}, 
		'php-03' => {
			'eth1' => '10.20.1.23',
			'eth0' => 'dhcp'
		}, 
		'php-04' => {
			'eth1' => '10.20.1.24',
			'eth0' => 'dhcp'
		},

		# web application servers with nginx .30 loadbalanced
		'web-01' => {
			'eth1' => '10.20.1.31',
			'eth0' => 'dhcp'
		},
		'web-02' => {
			'eth1' => '10.20.1.32',
			'eth0' => 'dhcp'
		},

		# cache servers .40 loadbalanced
		'cache-01' => {
			'eth1' => '10.20.1.41',
			'eth0' => 'dhcp'
		},
		'cache-02' => {
			'eth1' => '10.20.1.42',
			'eth0' => 'dhcp'
		},

		# search servers .50 loadbalanced
		'search-01' => {
			'eth1' => '10.20.1.51',
			'eth0' => 'dhcp'
		},
		'search-02' => {
			'eth1' => '10.20.1.52',
			'eth0' => 'dhcp'
		}

	}

}






