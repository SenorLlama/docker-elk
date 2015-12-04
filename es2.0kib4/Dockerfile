FROM ubuntu:14.04
MAINTAINER "Marvin Guerra"

# set debian frontend to noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install base libs
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
	apt-get -y update && apt-get install -y wget software-properties-common apache2 htop

# install oracle java from PPA
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update && \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	apt-get -y install oracle-java8-installer && apt-get clean

# install elasticsearch and logstash
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
	echo "deb http://packages.elastic.co/elasticsearch/2.0/debian stable main" > /etc/apt/sources.list && \
	apt-get update && apt-get install -y elasticsearch && \
	echo "deb http://packages.elasticsearch.org/logstash/2.0/debian stable main" > /etc/apt/sources.list && \
	apt-get update && apt-get install -y logstash

# install kibana
RUN sudo groupadd -g 999 kibana && \
	sudo useradd -u 999 -g 999 kibana && \
	wget https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz && \
	tar xvf kibana-*.tar.gz && \
	sudo mkdir -p /opt/kibana && \
	sudo cp -R ~/kibana-4*/* /opt/kibana/ && \
	sudo chown -R kibana: /opt/kibana && \
	cd /etc/init.d && sudo curl -o kibana https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/fc5025c3fc499ad8262aff34ba7fde8c87ead7c0/kibana-4.x-init && \
	cd /etc/default && sudo curl -o kibana https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/fc5025c3fc499ad8262aff34ba7fde8c87ead7c0/kibana-4.x-default && \
	sudo chmod +x /etc/init.d/kibana && \
	sudo update-rc.d kibana defaults 96 9 && \
	sudo service kibana start && \
	rmdir kibana-4* && \
	rm -f kibana-*.tar.gz

# configure htop
ADD htoprc /root/.config/htop/htoprc

# configure elasticsearch
RUN update-rc.d elasticsearch defaults 95 10 && \
	service elasticsearch start && \
	/usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

# configure logstash
ADD logstash.conf /etc/logstash/conf.d/logstash.conf
RUN service logstash start

# Expose ports needed
EXPOSE 80
EXPOSE 9200
EXPOSE 9400

# setup entrypoint
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]
