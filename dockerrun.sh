#!/bin/bash
sudo docker run -d -p 9292:80 -p 9200:9200 -p 9300:9300 -p 8877:8877 -p 5577:5577 -p 12201:12201 logstash