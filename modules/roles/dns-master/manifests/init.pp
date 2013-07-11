class dns-master { 
	include network
	include common

	include bind9
	include bind9::master
	include bind9::servicerunning
}
