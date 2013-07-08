module Puppet::Parser::Functions
	newfunction(:create_interfaces_file) do |args|
		network = args[0]

		fqdn = lookupvar('fqdn')
		hostname = lookupvar('hostname')
		
		domain = network['domain']
		gateway = network['gateway']
		netmask = network['netmask']
		members = network['members']


		# default core ip
		ip_eth0 = 'dhcp'
		ip_eth1 = '10.20.1.250'

		# fetch right ip by name
		members.each do |key, val|
   			if (key == hostname)
   				ip_eth0 = val['eth0']
   				ip_eth1 = val['eth1']
   			end
   		end

		# build the test string and write it to masters tmp file
		str = "full qualified domain name: "
		str += fqdn
		str += "\nhostname: "
		str += hostname
		
		str += "\ndomain: "
		str += domain
		
		str += "\neth0: "
		str += ip_eth0
		str += "\neth1: "
		str += ip_eth1

		
		str += "\ngateway: "
		str += gateway

		str += "\nnetmask: "
		str += netmask
		

		f = File.new("/tmp/puppet_network", "w+")
		f.write(str)
		f.close()
	end
end