class service-jenkins {

	package { "openjdk-7-jre":
		ensure => installed
	} ->
	
	class { '::jenkins': }

}
