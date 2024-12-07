#!/bin/sh

rsyslogd

CONTAINER_NAME=$(hostname)

sed -i "s/Hostname=.*/Hostname=$CONTAINER_NAME/" /etc/zabbix/zabbix_agent2.conf

/usr/sbin/zabbix_agent2 &


pm2-runtime start build/index.js --output /var/log/pm2/out.log --error /var/log/pm2/error.log