class service-webproxy {

	class { '::nginx': }

	# fetch all exported proxy members
	Service-webproxy::Member <<||>>


	#upstream web_servers {
	#    server web-01.development.claudio.dev max_fails=2 fail_timeout=30s;
	#    server web-02.development.claudio.dev max_fails=2 fail_timeout=30s;
	#}

	#server {
	#    listen 80;
	#    server_name web.development.claudio.dev;
	#    access_log /var/log/nginx/web.development.claudio.dev.access.log;
	#    error_log /var/log/nginx/web.development.claudio.dev.error.log;#

	#    location / {
	#        proxy_pass http://web_servers;
	#    }
	#}


	### DNS RoundRObin
	#www	IN  A   192.168.0.7
    #		IN  A   192.168.0.8

	### NGINX Configuration
	#upstream web_servers {
	#    server server_1.unixclinic.net:8001 max_fails=2 fail_timeout=30s;
	#    server server_2.unixclinic.net:8001 max_fails=2 fail_timeout=30s;
	#}

	#server {
	#	listen 80;
	#	server_name unixclinic.net;
	#	access_log /var/log/nginx/rproxy_1-access.log;
	#	error_log /var/log/nginx/rproxy_1-error.log;

	#	location / {
	#		proxy_pass http://web_servers;
	#	}
	#}

}
