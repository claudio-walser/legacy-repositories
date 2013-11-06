## nodes.pp

### default node handles everything by hostname
node default {
	# include defaul rend do common stuff
	include role

	# fetch node role and node number out of hostname. Match example:
	# (anything-but-last-one-or-two-numbers-is-the-role)-01
	if $hostname =~ /(.*)-([\d]{1,2})$/ {
		$node_role = $1
		$node_number = $2

		$role_class  = "role::$node_role"
		include $role_class
	}
	
}

# dynamic nodes, get role by name
# due to bug: http://projects.puppetlabs.com/issues/5898
# this might look a little weird, but works
# except for a host named "whatttt-*"
#node /whatttt|(.*)-([\d]{1,2})$/ {
#	fail("$1 bam $2")
#	include role
#	$::node_role = $1;
#	$::node_number = $2;
#	#include role::"${1}"
#}

### might outsource in typed nodefiles soon ###

### Puppetmaster
#node /^puppet-master-[0-9]{1,2}.*$/ {
#	include role::puppetmaster
#}
### Puppetmaster

### dns nodes
#node /^dns-[0-9]{1,2}.*$/ {
#	include role::dns
#}
### dns nodes

### Build Host for building live cd
#node /^build-[0-9]{1,2}.*$/ {
#	include role::build
#}
### Build Host for building live cd


### gitlab nodes
#node /^git-[0-9]{1,2}.*$/ {
#	include role::gitlab
#}
### gitlab nodes


### jenkins nodes
#node /^jenkins-[0-9]{1,2}.*$/ {
#	include role::jenkins
#}
### jenkins nodes


### monitoring nodes
#node /^monitor-[0-9]{1,2}.*$/ {
#	include role::icinga
#}
### monitoring nodes

### mediawiki nodes
#node /^wiki-[0-9]{1,2}.*$/ {
#	include role::wiki
#}
### mediawiki nodes



