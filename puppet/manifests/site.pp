# Defaults
Exec {
	path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

# configs and node definitions
import 'config.pp'
import 'network.pp'
import 'nodes.pp'