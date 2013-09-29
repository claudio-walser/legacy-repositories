# deploy monitoring server icinga
#
class service-icinga::server {
  
  # install mysql-server with root password icinga
  class { '::mysql::server':
    root_password => 'icinga'
  }

  mysql::db { 'icinga': 
    user => 'icinga-idoutils',
    password => 'zQXshujXFcXe',
    grant => 'ALL',
    charset => 'utf8',
    collate => 'utf8_general_ci',
    host => 'localhost',
    sql => "/mnt/backup/${domain}/${hostname}/setup/icinga.sql",
    enforce_sql => false,
    ensure => 'present'
  }

  mysql::db { 'icinga_web': 
    user => 'icinga_web',
    password => 'MNfRBpxgpSXg',
    grant => 'ALL',
    charset => 'utf8',
    collate => 'utf8_general_ci',
    host => 'localhost',
    sql => "/mnt/backup/${domain}/${hostname}/setup/icinga_web.sql",
    enforce_sql => false,
    ensure => 'present'
  }  

  # icinga db name: icinga
  # icinga db user: icinga-idoutils
  # icinga db pass: zQXshujXFcXe (guess its random each installation)


  package {[
    'icinga',
    'icinga-web'
    ]:
      ensure => 'installed'
  }

}
