class service-gitlab {

    $fixed_ip = get_host_ip($network)

    # dependencies
    package {
        ['build-essential',
            'zlib1g-dev',
            'libyaml-dev',
            'libssl-dev',
            'libgdbm-dev',
            'libreadline-dev',
            'libncurses5-dev',
            'libffi-dev',
            'curl',
            'git-core',
            'redis-server',
            'checkinstall',
            'libxml2-dev',
            'libxslt-dev',
            'libcurl4-openssl-dev',
            'libicu-dev',
            'python2.7',
            'ruby'
            ]: 
        ensure => installed 
    } ->

    # gitlab
    file { '/etc/apt/sources.list.d/gitlab.list':
        owner => 'root',
        group => 'root',
        ensure => 'file',
        content =>  "deb http://debian.fastlaneventures.ru/gitlab wheezy/\ndeb-src http://debian.fastlaneventures.ru/gitlab wheezy/"
    } ->

    exec { 'git-apt-update':
        command => "apt-get update",
        path => '/usr/bin'
    } ->

    exec { 'git-apt-install':
        command => "apt-get --force-yes install gitlab",
        path => '/usr/bin'
    } ->


    # default motd
    file {'/etc/gitlab/unicorn.rb':
        ensure  => file,
        mode    => 0644,
        content => template("service-gitlab/etc/gitlab/unicorn.rb.erb")
    } ->

    file {'/etc/gitlab/gitlab.yml':
        ensure  => file,
        mode    => 0644,
        content => template("service-gitlab/etc/gitlab/gitlab.yml.erb")
    }->

    service { "gitlab":
        enable => true,
        ensure => running
    }

}
