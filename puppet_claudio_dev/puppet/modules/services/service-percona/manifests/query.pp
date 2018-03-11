define service-percona::query (
	$user,
	$password,
	$query = $name,
	$creates = false
) {

	#fail("/usr/bin/mysql -u${user} -p${password} -e  \"${query}\"")
	exec { "service-percona::database-${query}":
		command => "/usr/bin/mysql -u${user} -p${password} -e \"${query}\"; return 0;",
		creates => $creates
	}

}