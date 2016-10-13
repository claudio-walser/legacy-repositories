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