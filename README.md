## Delete all Docker Containers ##
sudo docker rm $(sudo docker ps -aq)

## Delete all Docker Images ##
sudo docker rmi -f $(sudo docker images -q)

## Build docker image from dockerfile ##
sudo docker build -rm -t elasticsearch-kibana ./

## Run docker image as container, using a local data dir as elasticsearch index ##
sudo docker run -d -it \
	--cidfile=cids/elasticsearch-claudio.cid \
	--name=elasticsearch-claudio \
	--hostname=elasticsearch-claudio \
	-v ~/Development/docker/elasticsearch-claudio:/var/lib/elasticsearch/ \
	elasticsearch-kibana:latest \
	/bin/bash;


## List docker containers ##
sudo docker ps

## get ip of docker container ##
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(cat elasticsearch-claudio.cid)

## open bash on existing container ##
sudo docker attach $(cat elasticsearch-claudio.cid)

## Run commands on running container ##
sudo docker exec $(cat elasticsearch-claudio.cid) '/usr/sbin/service elasticsearch start && /usr/sbin/service kibana start'

## kibana proxying ## 
https://www.google.ch/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8&client=ubuntu#q=kibana+nginx+proxy+server.basePath
https://discuss.elastic.co/t/4-3-0-how-to-configure-your-nginx-balancer-and-apache-reverse-proxy/37351/4
http://stackoverflow.com/questions/36266776/kibana-server-basepath-results-in-404


## nginx example config ##
    location /elasticsearch-claudio {
      rewrite ^/elasticsearch-claudio(.*) /$1 break;
      proxy_pass http://elasticsearch-claudio:9200;
    }

    location /elasticsearch-claudio/kibana {
      rewrite ^/elasticsearch-claudio/kibana/(.*) /$1 break;
      proxy_pass http://elasticsearch-claudio:5601; }
    }

with server.basePath: "/elasticsearch-claudio/kibana" in kibana.yml

## issue a certificate for nginx ##
https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04