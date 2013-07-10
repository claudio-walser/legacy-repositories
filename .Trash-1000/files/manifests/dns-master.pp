class role::dns-master { 
	#include ::component::network::main
	include ::component::common::main

	include ::service::bind9::main
	include ::service::bind9::master
	include ::service::bind9::servicerunning
}
