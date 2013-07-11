class dns-slave { 
	include network
	include common
	
	include bind9
	include bind9::slave
	include bind9::servicerunning
}
