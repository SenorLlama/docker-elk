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
RUN wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
	echo "deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main" > /etc/apt/sources.list && \
	apt-get update && apt-get install -y elasticsearch && \
	echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" > /etc/apt/sources.list && \
	apt-get update && apt-get install -y logstash

# install kibana
RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz && \
	tar xf kibana-3.1.2.tar.gz && \
	rm -f /var/www/html/index.html && \
	mv kibana-3.1.2/* /var/www/html/ && \
	rmdir kibana-3.1.2 && \
	rm -f kibana-3.1.2.tar.gz

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