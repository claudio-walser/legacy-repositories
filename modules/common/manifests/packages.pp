class common::packages {	
	package {[
		"openssh-server",
		"openssh-client"
	]: 
		ensure => installed 
	}

	service { "ssh":
		ensure => running
	}

}