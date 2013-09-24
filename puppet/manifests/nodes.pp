## nodes.pp

# default node if unknown
node default {
	include role
}

## might outsource in typed nodefiles soon


## dns nodes
node /^dns-[0-9]{1,2}.*$/ {
	include role::dns
}
## dns nodes

### Build Host for building live cd
node /^build-[0-9]{1,2}.*$/ {
	include role::build
}
### Build Host for building live cd


## gitlab nodes
node /^git-[0-9]{1,2}.*$/ {
	include role::gitlab
}
## gitlab nodes


## jenkins nodes
node /^jenkins-[0-9]{1,2}.*$/ {
	include role::jenkins
}
## jenkins nodes


