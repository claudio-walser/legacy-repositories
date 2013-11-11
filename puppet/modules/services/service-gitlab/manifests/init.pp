class service-gitlab (
    db_name = 'gitlab',
    db_user = 'gitlab',
    db_pass = 'gitlab'
) { 

    # prerequisites
    #class { '::nginx': } ->
    
    package { [
        'g++',
        'nginx',
        'ruby1.9.3',
        # redis puppet modules are a nightmare, at least with librarian-puppet
        'redis-server'
    ]:
        ensure => 'installed'
    }
    
    # install mysql-server with root password icinga
    class { '::mysql::server': }

    mysql::db { $db_name: 
        user => $db_user,
        password => $db_pass,
        grant => 'ALL',
        charset => 'utf8',
        collate => 'utf8_general_ci',
        host => 'localhost',
        enforce_sql => false,
        ensure => 'present'
    }

    class { '::gitlab':
        git_email         => 'cwa@uwd.ch',
        git_comment       => 'GitLab',
        gitlab_domain     => $fqdn,
        gitlab_dbtype     => 'mysql',
        gitlab_dbname     => $db_name,
        gitlab_dbuser     => $db_user,
        gitlab_dbpwd      => $db_pass,
        require           => Package['g++', 'nginx', 'ruby1.9.3', 'redis-server']
    }
}
