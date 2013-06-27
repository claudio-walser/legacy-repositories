## nodes.pp

node default {
	include common,
}

node /^dns-[0-9]{1,2}\.claudio\.dev$/ {
	include common,
	include bind9,
}