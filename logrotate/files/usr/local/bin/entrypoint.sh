#!/bin/sh


if [ -z "$LOGROTATE_PATTERN" ]; then
  echo '$LOGROTATE_PATTERN must be set';
  exit;
fi

CRON_SCHEDULE=${CRON_SCHEDULE:-"0 * * * *"}
LOGROTATE_FREQUENCY=${LOGROTATE_FREQUENCY:-"daily"}
LOGROTATE_ROTATE=${LOGROTATE_ROTATE:-"31"}
LOGROTATE_MODE=${LOGROTATE_MODE:-"copytruncate"}

mkdir -p /var/spool/cron/crontabs
cat /etc/logrotate.tpl.conf | envsubst > /etc/logrotate.conf
echo "$CRON_SCHEDULE /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

exec busybox crond -f -L /dev/stdout
