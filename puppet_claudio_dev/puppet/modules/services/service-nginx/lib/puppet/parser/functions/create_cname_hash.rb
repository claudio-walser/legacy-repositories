module Puppet::Parser::Functions
	newfunction(:create_cname_hash, :type => :rvalue) do |args|
		hostname_array = args[0]

		array = Array.new()

		hostname_array.each do |val|
   			array.push(val)
   			array.push(Hash.new)
   		end
		
		#array  = array.flatten
		result = Hash[*array]

		result

	end
end