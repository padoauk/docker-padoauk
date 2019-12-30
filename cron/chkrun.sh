#!/bin/bash

# check PIDFILE and process and run CMD if necessary

export PATH=".:${HOME}/bin:${PATH}"

function help(){
    echo $(basename $0) command arg1 arg2 ...
}

PIDFILE="${HOME}/$(basename $1).pid"
PIDFILE_VALID_SEC=120

LOG="chkrun.log"
RET=""
# all the options as CMD to invoke
CMD=""; for x in $@; do CMD="${CMD} $x"; done

function exec_cmd(){
    echo $$ > $PIDFILE
    exec $CMD
}

# state is normal if all the following are true
# (1) PIDFILE exist
# (2) PID of PIDFILE is running process
function check_process(){
    # check if pidfile exists
    if [ ! -f "$PIDFILE" ]; then
	RET="1" # no pidfile
	return $RET
    fi

    # chcck if PIDFILE is empty
    local pid=$(cat $PIDFILE)
    if [ -z "$pid" ]; then
	RET="2" # nothing in pidfile
	return $RET
    fi

    # check if process of PIDFILE exists
    local x=$(ps auxww | awk '{print $2}' | grep "$pid")
    if [ -z "$x" ]; then
	RET="3"     # PIDFILE exist but not the process
	return $RET
    fi

    # check if PIDFILE modification time is younger than $PIDFILE_VALID_SEC
    local now=$(date +%s)
    local mtm=$(stat -c %Z $PIDFILE)
    local age=$(($now - $mtm))
    if [ $age -gt $PIDFILE_VALID_SEC ]; then
	RET="4"
	return $RET
    fi
    
    RET="0"
    return $RET
}

## Main
check_process
if [ $RET = "0" ]; then
    # the process is running and nothing to do
    touch $PIDFILE
    exit 0
fi

echo $(date +'%Y-%m-%dT%H:%M:%S') status $RET >> $LOG
exec_cmd
   
