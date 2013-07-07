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
    }

}
