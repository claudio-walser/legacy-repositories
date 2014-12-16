class gitlab (
	$data_dir = '/var/opt/gitlab/git-data/',
	$backup_dir = '/var/opt/gitlab/backups/',
	$gitlab_url = $::fqdn,
	$gitlab_ci = false,
	$gitlab_ci_url = "ci.${::fqdn}"
) {

	$dependencies = [
		'openssh-server',
		'postfix',
		'wget'
	]

	package { $dependencies:
		ensure => installed,
	}

	file { [
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