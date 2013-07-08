module Puppet::Parser::Functions
	newfunction(:create_interfaces_file) do |args|
		File.open('/tmp/puppet_network_test', File::RDWR|File::CREAT, 0755) {|f|
			f.write('str')
		}
		
		fqdn = lookupvar('{fqdn}')
		hostname = lookupvar('{hostname}')

		str = "{fqdn} + {hostname}"
		f = File.new("/tmp/puppet_network", "w")
		f.write('holy mother of god')

		File.open('/tmp/puppet_network', File::RDWR|File::CREAT, 0755) {|f|
			f.write(str)
		}

		print('Test')
		print(File.new("/tmp/xxx", "w").path)
	end
end