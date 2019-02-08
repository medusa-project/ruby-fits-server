#!/bin/bash --login

PID_DIR="run"
PID_FILE="$PID_DIR/ruby-fits-server-queue.pid"
LOG_DIR="log"
LOG_FILE="$LOG_DIR/ruby-fits-server-queue.log"
ERROR_FILE="$LOG_DIR/ruby-fits-server-queue.err"
mkdir -p $PID_DIR
mkdir -p $LOG_DIR
unset FITS_HOME

case "$1" in
    start)
	if [ -f $PID_FILE ]; then
	    PID=`cat $PID_FILE`
	    echo "The server appears to be running with pid: $PID"
	else
	    nohup bundle exec ./run-queue.rb run 2>> $ERROR_FILE >> $LOG_FILE < /dev/null &
	    echo $! > $PID_FILE
	    echo "Started ruby-fits-server-queue.rb with pid: $!"
	fi
	;;
    stop)
	if [ -f $PID_FILE ]; then
	    PID=`cat $PID_FILE`
	    COMMAND=`ps -p $PID -o comm=`
	    if [[ "$COMMAND" =~ java$ ]]; then
		    echo "Killing ruby-fits-server-queue.rb pid: $PID"
		    kill $PID
      elif [[ ${COMMAND##/*/} = "./run-queue.rb run" ]]; then
        echo "Killing ruby-fits-server-queue.rb pid: $PID"
        kill $PID
      elif [[ ${COMMAND##/*/} = "bundle" ]]; then
        echo "Killing ruby-fits-server-queue.rb pid: $PID"
        kill $PID
	    else
		echo "Process $PID is not ruby-fits-server-queue.rb; removing stale pid file"
	    fi
	    rm $PID_FILE
	else
	    echo "The server does not seem to be running; no pid file found."
	fi
	;;
    toggle-halt)
	if [ -f $PID_FILE ]; then
	    PID=`cat $PID_FILE`
	    kill -USR2 $PID
	    sleep 1 
	    tail -n 1 'log/ruby-fits-server-queue.log'
	else
	    echo "The server does not seem to be running; no pid file found."
	fi
	;;
    *)
	echo "Unrecognized command $1"
	;;
esac
