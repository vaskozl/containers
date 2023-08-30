#!/bin/sh

cat /etc/logrotate.tpl.conf | envsubst > /etc/logrotate.conf

if [ -z $LOGROTATE_PATTERN ]; then
  echo '$LOGROTATE_PATTERN must be set';
  exit;
fi

echo "$CRON_SCHEDULE /usr/sbin/logrotate /etc/logrotate.conf" | crontab -

exec tini $@
