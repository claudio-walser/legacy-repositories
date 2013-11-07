class service-redmine {
    # get role name	
	$node_role = get_node_role($hostname)

	# install mysql-server with root password icinga
	class { '::mysql::server':
	#	root_password => 'icinga'
	} ->

	mysql::db { 'redmine': 
		user => 'redmine',
		password => 'redmine',
		grant => 'ALL',
		charset => 'utf8',
		collate => 'utf8_general_ci',
		host => 'localhost',
		sql => "/mnt/backup/${domain}/${node_role}/backup/mysql/latest/redmine.sql",
		enforce_sql => false,
		ensure => 'present'
	} ->

	# Install Apache with mod php
	class {'::apache':
		mpm_module => 'prefork'
	}

	class {'::apache::mod::headers': }
	class {'::apache::mod::passenger': }

	apache::vhost { $fqdn:
      port    => '80',
      docroot => '/var/www',
      directories => [ {
	      provider => 'directory',
	      path => '/var/www/redmine',
	      options => 'Indexes FollowSymLinks MultiViews',
	      allow_override => 'none',
	      directoryindex => $directoryindex,
	      order => 'allow,deny',
	      allow => 'from all',
	      rails_base_uri => '/redmine',
	      passenger_resolve_symlinks_in_document_root => 'on'
	    } ]
    }



	# install debian mediawiki packages
	package { [
		'redmine',
		'redmine-mysql'
	]:
		ensure => 'installed'
	}

	# symlink mediawiki htdocs
	# ln -s /var/lib/mediawiki/ /var/www/wiki
	file { 'symlink-/var/www/redmine/':
		path => '/var/www/redmine/',
		ensure => 'link',
		owner => 'www-data',
		group => 'www-data',
		target => '/usr/share/redmine/public'
	}

}
