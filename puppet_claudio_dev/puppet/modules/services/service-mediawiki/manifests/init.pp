class service-mediawiki {
    # get role name	
	$node_role = get_node_role($hostname)

	# install mysql-server with root password icinga
	class { '::mysql::server':
	#	root_password => 'icinga'
	} ->

	mysql::db { 'mediawiki': 
		user => 'mediawiki',
		password => 'mediawiki',
		grant => 'ALL',
		charset => 'utf8',
		collate => 'utf8_general_ci',
		host => 'localhost',
		sql => "/mnt/backup/${domain}/${node_role}/backup/mysql/latest/mediawiki.sql",
		enforce_sql => false,
		ensure => 'present'
	} ->

	# Install Apache with mod php
	class {'::apache':
		mpm_module => 'prefork'
	}

	class {'::apache::mod::headers': }
	class {'::apache::mod::php': }

	

	#install needed php packages
	package { [
		'php5-imagick',
		'php5-gd',
		'php5-intl',
		'php-apc'
	]:
		 ensure => "installed"
	} ->


	# install debian mediawiki packages
	package { [
		'mediawiki',
		'mediawiki-extensions',
		'mediawiki-extensions-base',
		'mediawiki-extensions-geshi',
		'mediawiki-extensions-graphviz',
		'mediawiki-extensions-collection'
	]:
		ensure => 'installed'
	} ->

	# symlink mediawiki htdocs
	# ln -s /var/lib/mediawiki/ /var/www/wiki
	file { '/var/www/wiki/':
		ensure => 'link',
		target => '/var/lib/mediawiki/'
	} ->

	file { '/usr/share/mediawiki/images/':
		ensure => 'directory',
		mode => 0600,
		owner => 'root',
		group => 'root'
	}

	file { '/etc/mediawiki/LocalSettings.php':
		ensure => 'file',
		mode => 0660,
		owner => 'www-data',
		group => 'www-data',
		source => "file:///mnt/backup/${domain}/${node_role}/backup/files/latest/etc/mediawiki/LocalSettings.php"
	}

}
