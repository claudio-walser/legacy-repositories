class role::dns-master { 
	include ::component::network
	include ::component::common

	include ::service::bind9
	include ::service::bind9::master
	include ::service::bind9::servicerunning
}
