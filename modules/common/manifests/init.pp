class common {

    package { "ssh": 
        ensure => installed 
    }

    service { "ssh":
        ensure => running
    }
}
