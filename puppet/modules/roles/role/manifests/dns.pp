class role::dns { 
	# install bind9
	include ::service-bind9

	# claudio.dev zone
	include ::data-bind::claudio-dev
}
