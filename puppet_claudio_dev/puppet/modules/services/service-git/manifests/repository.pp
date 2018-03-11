define service-git::repository (
	$repo_url = undef,
	$target_directory = undef
) {

	# check dependencies
	# class exists vcsrepo


	# check params properly
	if $repo_url != undef {
		# ensure package git is present
		if ! defined(Package['git']) {
			package {'git':
				ensure => 'installed'
			}
		}
		
		# if no target_directory defined we dont have a target to checkout
		if $target_directory == undef {
			error('You cannot use service-git::repository path without a target_directory to checkout into.')
		}
		
		exec {"mkdir -p ${target_directory} - git_target_directory":
			command => "mkdir -p ${target_directory}",
			path => "/bin/"
		}

		# git checkout with module
		vcsrepo { $target_directory:
			ensure => present,
			provider => git,
			source => $repo_url,
			require => Package ['git']
		}
	}

}