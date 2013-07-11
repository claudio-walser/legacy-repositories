## nodes.pp

# default node if unknown
node default {
	include role
}

## might outsource in typed nodefiles soon


## dns nodes
# master node
node 'dns-01.claudio.dev' {
	include role::dns
}

#slave node
node 'dns-02.claudio.dev' {
	include role::dns
}
## dns nodes

## gitlab nodes
node 'git-01.claudio.dev' {
	include role::gitlab
}
## gitlab nodes