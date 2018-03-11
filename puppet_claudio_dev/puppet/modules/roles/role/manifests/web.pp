class role::web (
	$vhosts = {},
	$gitRepositories = {}
) {
	
	# install nginx service with php
	::service-nginx::server{$::fqdn: }
	::service-nginx::php {$::fqdn: }
	
	## create vhosts from hiera	
	if is_hash($vhosts) {
		create_resources( '::service-nginx::vhost', $vhosts)
	}

	## create git repos to easy checkout code
	if is_hash($gitRepositories) {
		create_resources( '::service-git::repository', $gitRepositories)
	}	

	class { 'composer':
		command_name => 'composer',
		target_dir   => '/usr/local/bin'
	}

}