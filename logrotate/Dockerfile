FROM public.ecr.aws/docker/library/alpine:3.18.3

ENV CRON_SCHEDULE='0 * * * *' \
    LOGROTATE_FREQUENCY='daily' \
    LOGROTATE_ROTATE='31' \
    LOGROTATE_MODE='create'

RUN apk --no-cache add logrotate tini gettext libintl \
    && mkdir -p /logs \
    && mkdir -p /etc/logrotate.d

COPY logrotate.tpl.conf /etc/logrotate.tpl.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/crond", "-f", "-L", "/dev/stdout"]
