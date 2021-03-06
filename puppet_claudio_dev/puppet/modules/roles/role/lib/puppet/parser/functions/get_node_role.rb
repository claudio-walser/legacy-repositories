module Puppet::Parser::Functions
	newfunction(:get_node_role, :type => :rvalue) do |args|
		hostname = args[0]

		# fetch node role and node number out of hostname. Match example:
		# (anything-but-last-one-or-two-numbers-is-the-role)-01
		if hostname =~ /(.*)-([\d]{1,2})$/
			$1
		else
			false
		end

	end
end