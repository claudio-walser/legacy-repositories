# i have no idea what to do with it yet but it looks very helpfull :p
$network = {
	'domain' => 'claudio.dev',

	'gateway' => '10.20.1.1',
	'netmask' => '255.255.255.0',
	'nameservers' => [
		'dns-01',
		'dns-02'
	 ],

	'members' => {

		#puppet masters
		'puppet-master-01' => {
			'eth1' => '10.20.1.2',
			'eth0' => 'dhcp'
		},


		#dns servers
		'dns-01' => {
			'eth1' => '10.20.1.3',
			'eth0' => 'dhcp'
		},
		'dns-02' => {
			'eth1' => '10.20.1.4',
			'eth0' => 'dhcp'
		},


		# mysql cluster
		'db-proxy01' => {
			'eth1' => '10.20.1.10',
			'eth0' => 'dhcp'
		},
		'db-proxy02' => {
			'eth1' => '10.20.1.11',
			'eth0' => 'dhcp'
		},
		'db-slave01' => {
			'eth1' => '10.20.1.12',
			'eth0' => 'dhcp'
		},
		'db-master02' => {
			'eth1' => '10.20.1.13',
			'eth0' => 'dhcp'
		},
		'db-slave01' => {
			'eth1' => '10.20.1.14',
			'eth0' => 'dhcp'
		},
		'db-slave02' => {
			'eth1' => '10.20.1.15',
			'eth0' => 'dhcp'
		}
	}

}






