module Puppet::Parser::Functions
	newfunction(:get_nodes_by_role, :type => :rvalue) do |args|
		role = args[0]
		port = args[1]

		if File.exists?("#{Puppet[:confdir]}/puppetdb.conf") then
			Puppet::Parser::Functions.autoloader.loadall

			query = "hostname~\"#{role}.*\""
			nodes = function_query_nodes( [query, 'hostname'] )
			candidates = nodes.select{|node| node =~  /^#{role}-\d+$/ or node == role}
			candidates = candidates.sort()
			if port != nil then
				portCandidates = Array.new()
				candidates.each do |candidate|
					portCandidates.push("#{candidate}:#{port}")
				end
				candidates = portCandidates
			end

			return candidates
		else
			return false
		end

	end

end