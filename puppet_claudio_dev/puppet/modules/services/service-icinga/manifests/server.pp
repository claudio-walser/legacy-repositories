# deploy monitoring server icinga
#
class service-icinga::server {
  
  # install mysql-server with root password icinga
  class { '::mysql::server':
  #		root_password => 'icinga'
  } ->

  mysql::db { 'icinga': 
    user => 'icinga-idoutils',
    password => 'zQXshujXFcXe',
    grant => 'ALL',
    charset => 'utf8',
    collate => 'utf8_general_ci',
    host => 'localhost',
    #sql => "/mnt/backup/${domain}/${hostname}/setup/icinga.sql",
    enforce_sql => false,
    ensure => 'present'
  } ->

  mysql::db { 'icinga_web': 
    user => 'icinga_web',
    password => 'MNfRBpxgpSXg',
    grant => 'ALL',
    charset => 'utf8',
    collate => 'utf8_general_ci',
    host => 'localhost',
    #sql => "/mnt/backup/${domain}/${hostname}/setup/icinga_web.sql",
    enforce_sql => false,
    ensure => 'present'
  } ->

  # setup password files as given from top as there is
  #   . /etc/icinga/ido2db.cfg
  #   - /usr/share/icinga-web/app/config/databases.xml
  #   - /etc/icinga-web/conf.d/database-ido.xml
  #   - /etc/icinga-web/conf.d/database-web.xml
  #   - rm -rf /var/cache/icinga-web/config/databases.xml_production->

  # example of xml lens from augeas
  #
  #augeas{"sipxprofile" :
  #      lens    => "Xml.lns",
  #      incl    => "/etc/sipxpbx/freeswitch/conf/sip_profiles/sipX_profile.xml",
  #      context => "/files/etc/sipxpbx/freeswitch/conf/sip_profiles/sipX_profile.xml",
  #      changes => [
  #        "set profile/settings/param[16]/#attribute/value $ipaddress",
  #        "set profile/settings/param[17]/#attribute/value $ipaddress",
  #      ],
  #      onlyif  => "get profile/settings/param[16]/#attribute/value != $ipaddress",
  #}
  

  package { 'icinga' :
      ensure => 'installed'
  } ->

  package { 'icinga-web' :
    ensure => 'installed'
  }

 
  Nagios_host <<||>>
  Nagios_host <||> {
    target => '/etc/icinga/objects/hosts_icinga.cfg'
  }

  Nagios_service <<||>>
  Nagios_service <||> {
    target => '/etc/icinga/objects/services_icinga.cfg'
  }  
}
