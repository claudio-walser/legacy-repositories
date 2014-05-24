class role::web (
	$vhosts = {},
	$gitRepositories = {}
) {
	
	# install git to checkout repos
	#package {'git':
	#	ensure => 'installed'
	#}
	
	# install nginx service with php
	::service-nginx::server{$::fqdn: }
	::service-nginx::php {$::fqdn: }
	
	## create vhosts from hiera	
	if is_hash($vhosts) {
		create_resources( '::service-nginx::vhost', $vhosts)
	}

	if is_hash($gitRepositories) {
		create_resources( '::service-git::repository', $gitRepositories)
	}	

}