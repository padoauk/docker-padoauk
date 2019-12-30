# cron invokes app in container
Crontab is parepared in container to invoke and monitor application(s) in it.
The crontab tasks can be defined in the file refered by ${crontab} in Dockerfile.

The utility script chkrun.sh checks whether application process is running and
invokes the application only if the application is not running. See app.crontab
as an sample.


