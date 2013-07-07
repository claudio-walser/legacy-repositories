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
	include bind9::servicerunning
}

#slave node
node 'dns-02.claudio.dev' {
	include common
	include bind9
	include bind9::slave
	include bind9::servicerunning
}
## dns nodes


## gitlab nodes
node 'git-01.claudio.dev' {
	include common
	include gitlab
}

## gitlab nodes