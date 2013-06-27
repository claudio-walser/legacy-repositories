## nodes.pp



node default {
	include common
}

node /^dns-[1-9]{1,2}\.claudio\.dev$/ {
	include common,
	include bind9
}