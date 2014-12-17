class gitlab::fixes::gitlab-ci (
	$url = $::fqdn
) {

	# omnibus fix, put the ci_external_url into /etc/gitlab/gitlab.rb does not work for me
	# so lets fix the chef recipe included in omnibus package
	# since its open source, ill try to fix that stuff in omnibus maybe
	file_line {'gitlab-ci-omnibus-fix':
		path => '/opt/gitlab/embedded/cookbooks/gitlab/libraries/gitlab.rb',
		line  => "      ci_external_url = 'http://${url}'",
		match => '^      (return unless ci_external_url|ci_external_url \= (.*))$',
		require => Exec['gitlab-install'],
		notify => [Exec['gitlab-reconfigure'],Exec['gitlab-ci-setup']]
	}

}