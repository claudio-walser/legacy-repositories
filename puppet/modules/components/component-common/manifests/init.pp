class component-common {
	include component-common::motd
	include component-common::administrators
	include component-common::packages
	include component-common::security
	include component-common::mounts
	include component-common::monitoring
	

	# todo: outsource into puppet-agent.pp
	ini_setting { 'runinterval':
		ensure  => present,
		path    => "/etc/puppet/puppet.conf",
		section => 'agent',
		setting => 'runinterval',
		value   => '2m'
	} ->
	
	# default puppet start params
	file {'/etc/default/puppet':
		ensure  => file,
		mode	=> 0644,
		source => "puppet:///modules/component-common/etc/default/puppet"
	} ->

	service { 'puppet':
		ensure  => running,
		enable  => true,
		hasstatus => true,
	}

	#todo
	# - ensure root password is changed
	# - ensure fail2ban is configured and running
	# - ensure failed logins are reported somewhere
	# - * done setup puppet agent as service
	# - * done ensure -claudio- admin is present and in sudoers
	# - * done by adding a user to group sudo / ensure only defined users can sudo
	# - * done ensure ssh root login disabled

}
