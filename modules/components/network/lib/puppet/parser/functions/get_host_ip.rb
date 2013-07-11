module Puppet::Parser::Functions
	newfunction(:get_host_ip, :type => :rvalue) do |args|
		network = args[0]
		staticEth = network['staticEth']
		members = network['members']
		hostname = lookupvar('hostname')
		staticEth = network['staticEth']

		defaultIp = '20.20.1.250'
		

		if network['members'][hostname].nil?
			defaultIp
		else
			network['members'][hostname][staticEth]
		end

	end
end