module Puppet::Parser::Functions
	newfunction(:get_internal_nameserver_ips, :type => :rvalue) do |args|
		network = args[0]
		staticEth = network['staticEth']
		nameserverIps = Array.new()
		
		network['internalNameservers'].each do |val|
   			nameserverIps.push(network['members'][val][network['staticEth']])
   		end

   		nameserverIps
	end
end