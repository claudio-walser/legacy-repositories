class dns-slave { 
	include ::component::network
	include ::component::common
	
	include ::service::bind9
	include ::service::bind9::slave
	include ::service::bind9::servicerunning
}
