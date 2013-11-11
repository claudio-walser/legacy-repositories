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
		sql => "/mnt/backup/${domain}/${node_role}/backup/mysql/latest/redmine-2.sql",
		enforce_sql => false,
		ensure => 'present'
	} ->

	# Install Apache with mod php
	class {'::apache':
		mpm_module => 'prefork'
	}

	class {'::apache::mod::headers': }
	class {'::apache::mod::passenger': }

	
	# install version 2.3.3-stable
	class {'::service-redmine::version-2-3-3': }
	# install debian mediawiki packages
	#package { [
	#	'redmine',
	#	'redmine-mysql'
	#]:
	#	ensure => 'installed'
	#}

	# symlink mediawiki htdocs
	# ln -s /var/lib/mediawiki/ /var/www/wiki
	file { 'ln -s /var/www/redmine/':
		path => '/var/www/redmine/',
		ensure => 'link',
		owner => 'www-data',
		group => 'www-data',
		target => '/opt/redmine/'
	} ->

	apache::vhost { $fqdn:
      port    => '80',
      docroot => '/var/www/redmine/public',
      directories => [ {
	      provider => 'directory',
	      path => '/var/www/redmine',
	      options => 'Indexes FollowSymLinks MultiViews',
	      allow_override => 'none',
	      directoryindex => $directoryindex,
	      order => 'allow,deny',
	      allow => 'from all',
	      
	      #rails_base_uri => '/redmine',
	      #passenger_resolve_symlinks_in_document_root => 'on'
	    } ]
    }

    include service-redmine::backup

}
