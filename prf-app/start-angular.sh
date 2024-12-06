#!/bin/sh

rsyslogd

CONTAINER_NAME=$(hostname)

sed -i "s/Hostname=.*/Hostname=$CONTAINER_NAME/" /etc/zabbix/zabbix_agent2.conf

/usr/sbin/zabbix_agent2 &

pm2-runtime start http-server --name 'angular-app' -- -p 4200 -d false ./dist/my-first-project/browser