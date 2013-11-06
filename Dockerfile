FROM base
MAINTAINER Juan Patten (jr@juanpatten.com)

# Install logstash
RUN echo "deb http://archive.ubuntu.com/ubuntu quantal main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y  software-properties-common python-software-properties git
RUN add-apt-repository ppa:nginx/stable

RUN apt-get update
RUN apt-get install -y wget openjdk-6-jre unzip curl vim
RUN apt-get install -y nginx-full

#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget nginx-full

RUN mkdir /usr/share/nginx/www/
RUN mkdir /usr/share/kibana3/
RUN wget https://download.elasticsearch.org/logstash/logstash/logstash-1.2.2-flatjar.jar -O /opt/logstash.jar --no-check-certificate
RUN (cd /tmp && wget --no-check-certificate http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -O pkg.zip && unzip pkg.zip && cd kibana-* && cp -rf ./* /usr/share/kibana3/)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Configure Logstash
ADD run.sh /usr/local/bin/run
ADD logstash.conf /opt/logstash.conf
ADD default /etc/nginx/sites-available/default

RUN chmod +x /usr/local/bin/run
RUN rm -rf /tmp/*

CMD ["/usr/local/bin/run"]
