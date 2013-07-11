## nodes.pp

# default node if unknown
node default {
	include base
}

## might outsource in typed nodefiles soon


## dns nodes
# master node
node 'dns-01.claudio.dev' {
	include dns
}

#slave node
node 'dns-02.claudio.dev' {
	include dns
}
## dns nodes


## gitlab nodes
node 'git-01.claudio.dev' {
	include gitlab
}
## gitlab nodes