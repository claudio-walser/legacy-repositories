class role::minimal {
	include ::profile-minimal
	
	# include puppet client 
	include ::service-puppet::client
}
