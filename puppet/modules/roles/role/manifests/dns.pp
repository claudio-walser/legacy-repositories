class role::dns { 
	# install bind9
	include ::service-bind9::server
}
