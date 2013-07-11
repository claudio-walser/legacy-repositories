module Puppet::Parser::Functions
	newfunction(:is_dns_node, :type => :rvalue) do |args|
		network = args[0]

		hostname = lookupvar('hostname')
		nameservers = network['internalNameservers']		

		# return hostname in nameserver array
		if nameservers.index(hostname).nil?
			false
		else
			true
		end

	end
end