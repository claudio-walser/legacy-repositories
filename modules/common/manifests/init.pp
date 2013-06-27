class common {

    package { "sshd": 
        ensure => installed 
    }

    service { "sshd":
        ensure => running
    }
}
