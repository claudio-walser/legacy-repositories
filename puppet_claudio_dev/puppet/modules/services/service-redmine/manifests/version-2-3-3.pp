class service-redmine::version-2-3-3 (
	$tarballUrl = 'http://files.rubyforge.vm.bytemark.co.uk/redmine/redmine-2.3.3.tar.gz',
	$packetName = 'redmine-2.3.3',
	$installationPath = '/opt/redmine' # make sure the parent directory, in this case /opt, already exists
) {
	# Batch script would be alot easier
	# ensure installation folder exists, think about puppet has no recursion
	# be sure the parent directory, in this case /opt, already exists
	file { $installationPath:
		ensure => 'directory'
	} ->
	# tarball download via wget
	exec { 'service-redmine::version-2-3-3-download-tarball':
		command => "wget ${tarballUrl}",
		cwd => "${installationPath}",
		path => '/usr/bin',
		creates => '/opt/redmine/public' # hope it doesent do the whole stack if this is true and everything depends on this ;)
	} ->

	# unzip tarball
	exec { 'service-redmine::version-2-3-3-unzip-tarball':
		command => "tar xzf ${packetName}.tar.gz",
		cwd => "${installationPath}",
		path => '/bin',
		creates => '/opt/redmine/public'
	} ->
	# remove download tarball after extracting
	exec { 'service-redmine::version-2-3-3-remove-tarball':
		command => "rm ${packetName}.tar.gz",
		cwd => "${installationPath}",
		path => '/bin',
		creates => '/opt/redmine/public'
	} ->
	# move one folder up
	exec { 'service-redmine::version-2-3-3-move-extracting-folder':
		command => "mv ${packetName}/* ./",
		cwd => "${installationPath}",
		path => '/bin',
		creates => '/opt/redmine/public'
	}
	# remove empty extracting
	exec { 'service-redmine::version-2-3-3-remove-extracting-folder':
		command => "rm -rf ${packetName}",
		cwd => "${installationPath}",
		path => '/bin'
	} ->

	# ensure plugin-assets directory
	file {'/opt/redmine/public/plugin_assets':
		ensure => 'directory',

	} ->

	# copy config files
	file { '/opt/redmine/config/database.yml':
		ensure => 'file',
		source => "puppet:///modules/service-redmine/redmine-2.3.3/opt/redmine/config/database.yml"
	} ->
	file { '/opt/redmine/config/configuration.yml':
		ensure => 'file',
		source => "puppet:///modules/service-redmine/redmine-2.3.3/opt/redmine/config/configuration.yml"
	} ->

	package { [
		'libmysqlclient-dev',
		'ruby1.9.1-dev',
		'libmagickcore-dev',
		'libmagickwand-dev',
		'imagemagick'
	]:
		ensure => 'installed'
	} ->

	package { [
		'bundler',
		'mysql2'
	]:
		ensure => 'installed',
		provider => 'gem'
	} ->
	
 	file { '/opt/redmine/backup.sh':
		ensure => 'file',
		source => "puppet:///modules/service-redmine/redmine-2.3.3/opt/redmine/backup.sh"
	} ->

	file { '/opt/redmine/restore.sh':
		ensure => 'file',
		source => "puppet:///modules/service-redmine/redmine-2.3.3/opt/redmine/restore.sh"
	} ->

	file { '/opt/redmine/install.sh':
		ensure => 'file',
		source => "puppet:///modules/service-redmine/redmine-2.3.3/opt/redmine/install.sh"
	} ->	

	# install latest backup
	exec { 'service-redmine::version-2-3-3-install-latest-backup':
		command => "bash /opt/redmine/install.sh",
		cwd => "${installationPath}",
		path => '/bin',
		creates => '/opt/redmine/installed'
	} ->

	# install redmine bundles
	exec { 'service-redmine::version-2-3-3-install-bundles':
		command => "bundle install --without development test postgresql sqlite",
		cwd => "${installationPath}",
		path => '/usr/local/bin'
	} ->

	
	# set owner to www-data
	exec { 'service-redmine::version-2-3-3-owner':
		command => "chown -R www-data:www-data /opt/redmine",
		cwd => "${installationPath}",
		path => '/bin'
	}
	# need to do it or at least restore the latest backup, maybe thats enough already
	#redmine@wiki-02:~# rake generate_secret_token
	#redmine@wiki-02:~# RAILS_ENV=production rake db:migrate
	#redmine@wiki-02:~# RAILS_ENV=production rake redmine:load_default_data

}