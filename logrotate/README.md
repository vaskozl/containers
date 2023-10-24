Based on https://github.com/honestbee/logrotate/tree/master

Must set the `LOGROTATE_PATTERN` env variable.

Optional variables and their defaults:
```bash
CRON_SCHEDULE='0 * * * *'
LOGROTATE_FREQUENCY='daily'
LOGROTATE_ROTATE='31'
LOGROTATE_MODE='copytruncate'
```
