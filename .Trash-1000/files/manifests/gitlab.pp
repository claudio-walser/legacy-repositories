class role::gitlab {
	include component::network
	include component::common
	
	include service::gitlab
}