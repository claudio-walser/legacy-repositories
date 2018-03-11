class gitlab::install {

	file { [
		'/opt/gitlab/',
		'/opt/gitlab/source/'
	]:
		ensure => directory
	}

	case $::operatingsystem {
		'Debian', 'Ubuntu' : {
			class { 'gitlab::install::debian': }
		}

		'RedHat', 'CentOS', 'Fedora' : {
			class { 'gitlab::install::centos': }
		}

		default : {
			fail("Operatingsystem ${::operatingsystem} not supported")
		}
	}

	file { '/etc/gitlab/gitlab.rb':
		ensure => file,
		content => '', # empty cause the default one is buggy, missing the equals
		require => Exec['gitlab-install']
	}
}