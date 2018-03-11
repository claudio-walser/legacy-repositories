module Puppet::Parser::Functions
	newfunction(:is_last_node, :type => :rvalue) do |args|

		if File.exists?("#{Puppet[:confdir]}/puppetdb.conf") then
			Puppet::Parser::Functions.autoloader.loadall
			role = args[0]
			hostname = args[1]

			query = "hostname~\"#{role}.*\""
			nodes = function_query_nodes( [query, 'hostname'] )
			candidates = nodes.select{|hostname| hostname =~  /^#{role}-\d+$/ or hostname == role}

			return hostname == candidates.sort.last
		else
			return false
		end

	end

end