class role::gitlab-ci {
	class {'::gitlab::ci':
		url => $::fqdn,
		gitlab_server_urls => ['http://gitlab-01.development.claudio.dev']
	}
}