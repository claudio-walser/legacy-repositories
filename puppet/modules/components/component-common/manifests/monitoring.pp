class component-common::monitoring {
	
	$fixed_ip = get_host_ip($network)

	# default motd
	@@nagios_host { $fqdn:
		address => $fixed_ip,
		alias => $hostname,
		use => 'generic-host'
	}

	@@nagios_service { "check_ping_${fqdn}":
		host_name => "${fqdn}",
		service_description => "Ping",
		# check_command check_ping!100.0,20%!500.0,60%
		check_command => "check_ping!50!1!100!5!5!10!4",
		use => 'generic-service'
	}

}

