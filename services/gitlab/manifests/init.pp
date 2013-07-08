class gitlab {

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


    user { 'git': 
        #uid        => 500, 
        #groups     => 'admin', 
        comment     => 'Gitlab', 
        ensure      => present, 
        home        => '/home/git', 
        shell       => '/bin/false', 
        managehome  => true, 
        password    => '$6$OprdC8Il$YuxNRSVU0cf1wMSp8bbnav8fWc5kwEk2N4nsbnJ7G8BWqwbUeH33kRRZpM4DETeQ1va02b21a07zp66DnwL/a0'
    } ->


    file { '/home/git/gitlab-shell':
        ensure => "directory",
        owner  => "git",
        group  => "git",
        mode   => 755
    } ->


    vcsrepo { '/home/git/gitlab-shell':
        source => 'https://github.com/gitlabhq/gitlab-shell.git',
        provider => git,
        owner => 'git',
        group => 'git',
        user => 'git',
        revision => 'v1.5.0'
    }
}
