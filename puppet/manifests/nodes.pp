## nodes.pp

# default node if unknown
node default {
	include role
}

## might outsource in typed nodefiles soon


## dns nodes
node /^dns-[0-9]{1,2}\.claudio\.dev$/ {
	include role::dns
}
## dns nodes

## gitlab nodes
node 'git-01.claudio.dev' {
	include role::gitlab
}
## gitlab nodes
