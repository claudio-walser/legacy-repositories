class gitlab::install {

	file { [
		'/opt/gitlab/',
		'/opt/gitlab/scripts/'
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
		owner => 'git',
		group => 'git'
	}
}