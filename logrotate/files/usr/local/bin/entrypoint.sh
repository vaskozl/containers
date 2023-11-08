#!/bin/sh


if [ -z "$LOGROTATE_PATTERN" ]; then
  echo '$LOGROTATE_PATTERN must be set';
  exit;
fi

export CRON_SCHEDULE=${CRON_SCHEDULE:-"0 * * * *"}
export LOGROTATE_FREQUENCY=${LOGROTATE_FREQUENCY:-"daily"}
export LOGROTATE_ROTATE=${LOGROTATE_ROTATE:-"31"}
export LOGROTATE_MODE=${LOGROTATE_MODE:-"copytruncate"}

mkdir -p /var/spool/cron/crontabs
cat /etc/logrotate.tpl.conf | envsubst > /etc/logrotate.conf
echo "$CRON_SCHEDULE /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

exec busybox crond -f -L /dev/stdout
