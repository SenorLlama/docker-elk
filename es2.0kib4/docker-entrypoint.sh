#!/bin/bash
set -e

echo 'Starting Elasticsearch'
service elasticsearch start
echo 'Starting syslog'
service rsyslog start
echo 'Starting Logstash'
service logstash start
echo 'Starting Kibana'
service kibana start

apache2ctl -D FOREGROUND

exec "$@"
