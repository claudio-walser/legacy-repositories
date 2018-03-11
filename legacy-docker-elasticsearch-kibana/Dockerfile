# Dockerfile for elasticsearch and kibana
# Version 0.0.1
FROM debian

MAINTAINER Claudio Walser <claudio.walser@srf.ch>

RUN apt-get install -y apt-utils; \
	apt-get update && apt-get upgrade -y; \
	apt-get install -y wget openjdk-7-jre-headless nano net-tools bash-completion; \
	/usr/bin/wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.1/elasticsearch-2.4.1.deb; \
	dpkg -i elasticsearch-2.4.1.deb; \
	rm elasticsearch-2.4.1.deb; \
	/usr/bin/wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-amd64.deb; \
	dpkg -i kibana-4.6.1-amd64.deb; \
	rm kibana-4.6.1-amd64.deb; \
	sed -i 's/# network.host: 192.168.0.1/network.host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml; \
	/usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ;
	
CMD /usr/sbin/service elasticsearch start; /usr/sbin/service kibana start;

EXPOSE 9200 9300 5601

#ADD webserver.py /opt/webserver/webserver.py
#ADD run.sh /opt/webserver/run.sh

#VOLUME ["~/.bash_history:/root/.bash_history"]