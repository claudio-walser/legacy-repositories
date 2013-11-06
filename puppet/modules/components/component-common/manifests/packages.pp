class component-common::packages {	
	package { [
		'openssh-server',
		'openssh-client',
		'bash-completion',
		'locate'
	]: 
		ensure => installed 
	}

}