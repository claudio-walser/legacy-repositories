class common {
	## common users
	include user::virtual

    package { "ssh": 
        ensure => installed 
    }

    service { "ssh":
        ensure => running
    }
}
