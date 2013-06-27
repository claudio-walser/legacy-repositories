# i have no idea what to do with it yet but it looks very helpfull :p
$environmentDomain = 'claudio.dev'

$network_front = '10.20.1.1'

$members = {
	'puppet' => {
		'puppet-master-01' => {
			'eth0' => '10.20.1.2',
			'eth1' => 'dhcp'
		}
	},

	'dns' => {
		'01' => {
			'eth0' => '10.20.1.8',
			'eth1' => 'dhcp'
		},
		'02' => {
			'eth0' => '10.20.1.9',
			'eth1' => 'dhcp'
		}
	},

	'mysql' => {
		'db-proxy01' => {
			'eth0' => '10.20.1.10',
			'eth1' => 'dhcp'
		},
		'db-proxy02' => {
			'eth0' => '10.20.1.11',
			'eth1' => 'dhcp'
		},
		'db-slave01' => {
			'eth0' => '10.20.1.12',
			'eth1' => 'dhcp'
		},
		'db-master02' => {
			'eth0' => '10.20.1.13',
			'eth1' => 'dhcp'
		},
		'db-slave01' => {
			'eth0' => '10.20.1.14',
			'eth1' => 'dhcp'
		},
		'db-slave02' => {
			'eth0' => '10.20.1.15',
			'eth1' => 'dhcp'
		}
	}
}






