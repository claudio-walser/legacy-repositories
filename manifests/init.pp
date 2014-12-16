class gitlab (
	$data_dir = '/var/opt/gitlab/git-data/',
	$backup_dir = '/var/opt/gitlab/backups/'
) {

	$dependencies = [
		'openssh-server',
		'postfix',
		'wget'
	]

	package { $dependencies:
		ensure => installed,
	}

	file { {
		'/opt/gitlab',
		'/opt/gitlab/source',
		'/opt/gitlab/scripts'
	]:
		ensure => directory,
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
		content => template("${module_name}/etc/gitlab/gitlab.rb.erb"),
		require => Exec['gitlab-install'],
		notify => Exec['gitlab-reconfigure']
	}
	# todo: put backup dir into /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml

	file { '/opt/gitlab/scripts/restore.sh':
		ensure => file,
		content => template("${module_name}/opt/gitlab/scripts/restore.sh.erb"),
		require => File['/opt/gitlab/scripts']
	}

	# reconfigure and restart only on refresh
	exec { 'gitlab-reconfigure':
		command	=> '/usr/bin/gitlab-ctl reconfigure',
		refreshonly => true,
		notify => Exec['gitlab-restart']
	}
	exec { 'gitlab-restart':
		command	=> '/usr/bin/gitlab-ctl restart',
		refreshonly => true
	}
}