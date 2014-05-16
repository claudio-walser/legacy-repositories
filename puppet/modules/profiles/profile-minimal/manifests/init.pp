class profile-minimal {
	
	# some default packages
	package { [
		"bash-completion"
	]:
		ensure => installed,
	}

}
