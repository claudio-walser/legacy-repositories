class gitlab::fixes::gitlab (
	$url = $::fqdn
) {

	# omnibus fix, put the external_url into /etc/gitlab/gitlab.rb does not work for me
	# so lets fix the chef recipe included in omnibus package
	# since its open source, ill try to fix that stuff in omnibus maybe
	file_line {'another-stupid-gitlab-omnibus-fix':
		path => '/opt/gitlab/embedded/cookbooks/gitlab/libraries/gitlab.rb',
		line  => "      external_url = 'http://${url}'",
		match => '^      (return unless external_url|external_url \= (.*))$',
		require => Exec['gitlab-install'],
		notify => [Exec['gitlab-reconfigure'],Exec['gitlab-ci-setup']]
	}

}