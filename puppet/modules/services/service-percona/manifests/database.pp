# See README.md for details.
define service-percona::database (
	$user,
	$password,
	$root_password = false,
	$dbname        = $name,
	$charset       = 'utf8',
	$collate       = 'utf8_general_ci',
	$host          = 'localhost',
	$grant         = 'ALL',
	$sql           = '',
	$enforce_sql   = false,
	$ensure        = 'present',
	$flush_privileges = false
) {
	#input validation
	validate_re($ensure, '^(present|absent)$',
	"${ensure} is not supported for ensure. Allowed values are 'present' and 'absent'.")


	if $ensure == 'present' {
		# create db
		$query_db = template("${module_name}/puppet/mysql_database_create.erb")
	} else {
		# drop db
		$query_db = template("${module_name}/puppet/mysql_database_drop.erb")
	}

	# take care check-file is written for present and removed for absent
	if $ensure == 'present' {
		$file_ensure = 'file'
	} else {
		$file_ensure = 'absent'
	}

	# perform create db query
	::service-percona::query { "create-db-query-${dbname}":
		query => $query_db,
		user => 'root',
		password => $root_password,
		creates => "/etc/mysql/${dbname}.created"
	} ->
	# write check file to only do it once
	file { "/etc/mysql/${dbname}.created":
		ensure => $file_ensure,
		content => 'created'
	}
	
}
