## nodes.pp

# default node if unknown
node default {
	include common
}

## might outsource in typed nodefiles soon


## dns nodes
# master node
node 'dns-01.claudio.dev' {
	include common
	include bind9
	include bind9::master
	#incluce bind9::service
}

#slave node
node 'dns-02.claudio.dev' {
	include common
	include bind9
	include bind9::slave
	#incluce bind9::service
}
## dns nodes
