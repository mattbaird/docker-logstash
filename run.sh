#!/bin/bash
ES_HOST=${ES_HOST:-0.0.0.0}
ES_PORT=${ES_PORT:-9200}

CONFIG_FILE="/opt/logstash.conf"

function config_replace() {
    CMD="s/{{$1}}/$2/g"
    sed -i'.bak' -e ${CMD} ${CONFIG_FILE}
}

config_replace "ES_HOST" "$ES_HOST"
config_replace "ES_PORT" "$ES_PORT"
cat << EOF > /usr/share/nginx/www/config.js
var config = new Settings(
{
  elasticsearch:    "http://$ES_HOST:$ES_PORT",
  kibana_index:     "kibana-int",
  modules:          ['histogram','map','pie','table','stringquery','sort',
                    'timepicker','text','fields','hits','dashcontrol',
                    'column','derivequeries','trends','bettermap'],
  }
);
EOF

nginx -c /etc/nginx/nginx.conf &

java -jar /opt/logstash.jar agent -f /opt/logstash.conf

