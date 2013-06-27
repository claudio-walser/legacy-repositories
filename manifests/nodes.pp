## nodes.pp

# default node if unknown
node default {
	include common
}

# dns nodes

#example regex for matching dns-(01-99||1-99)
#node /^dns-[0-9]{1,2}\.claudio\.dev$/ {
# dns base installation
node 'baseDns' {
	include common
	include bind9
}
# master node
node 'dns-01.claudio.dev' inherits 'baseDns' {
	include bind9::master
}
#slave node
node 'dns-02.claudio.dev' inherits 'baseDns' {
	include bind9::slave
}