define service-bind9::resolvconf (
	$type = "slave",
	$ip
) {
	
	$file = '/etc/resolv.conf'

	$resolvconfHeader = "domain development.claudio.dev\nsearch development.claudio.dev\n "
	
	if ! defined(Concat[$file]) {
		concat { $file:
			ensure_newline => true
		}
	}
	
	concat::fragment { "service-bind9::resolvconf-header-${name}":
		target  => $file,
		content => $resolvconfHeader,
		order   => '01'
	}

	if $type == 'master' {
		concat::fragment { "service-bind9::resolvconf-master-${name}":
			target  => $file,
			content => "nameserver ${ip}",
			order   => '02'
		}
	} else {
		concat::fragment { "service-bind9::resolvconf-slave-${name}":
			target  => $file,
			content => "nameserver ${ip}",
			order   => '03'
		}
	}

	concat::fragment { "service-bind9::resolvconf-slave-${name}":
		target  => $file,
		content => "\ntimeout 3",
		order   => '04'
	}
}
