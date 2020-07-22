# Rotate Logging with Bash Script
## Instructions

Set up the script to be executed as a cron job. 

`crontab -e` \
`*/5 * * * * <path to script>`

Execute `./rotatelog.sh` with full file path as the 1st argument and log size limiter in MB as the 2nd argument.

Example:

`./rotatelog.sh /var/log/random.log 5`

## Description
Log rotation is an automated process used in system administration in which log files are compressed, archived, renamed or deleted once they are too old and/or too big.

In this script, the default log size limiter is 50 MB and logs that haven't reach the limited size will be archived at 00.05 the next day.
