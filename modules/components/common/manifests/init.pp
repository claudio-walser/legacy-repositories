class common {
	include common::motd
	include common::administrators
	include common::packages
	include common::security

	#todo
	# -  create cronjob with 'puppet agent --test --server "puppet-master-01.claudio.dev"'
	# - * think its not needed ensure root user and group is present
	# - * done densure -claudio- admin is present and in sudoers
	# - * done by adding a user to group sudo / ensure only defined users can sudo
	# - * done ensure ssh root login disabled
	# - esnure fail2ban is configured and running
	# - ensure failed logins are reported somewhere

}
