class role::web {
	class{ '::service-nginx':
		git => true
	}
	include ::service-nginx::php
	
	# load project spaf onto the webservers
	include ::role::web::spaf
	include ::role::web::phpdocumentor
	include ::role::web::test
}