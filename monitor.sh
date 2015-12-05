#!/bin/bash
# +-------------------------------------------------------------+
# | this script takes 2 arguments: the first one being either a |
# | programm name or a PID, and the second one being an integer |
# | value N. the script continously checks every N seconds if	|
# | the given process is still running.				|
# |								|
# | USAGE:							|
# | ./monitor.sh <programm name or PID> <seconds to sleep>	|
# | EXAMPLE:							|
# | ./monitor.sh chromium 1					|
# +-------------------------------------------------------------+

if [[ $# -lt 2 ]]; then
	echo not enough arguments supplied, try again
elif [[ $# -eq 2 ]]; then
	#check if arg2 is a number
	if [ "$2" -eq "$2" ] 2>/dev/null; then
		# check for given PID/name; check if arg1 is a number
		if [ "$1" -eq "$1" ] 2>/dev/null; then
			echo "using PID"
			PID=$1
		else
			PID=$(pgrep $1)
			NUMBER=$(echo $PID | wc -l)
			if [ $NUMBER = 0 ]; then
				echo "no process was found when searching for $1"
				exit -1
			elif [ $NUMBER -gt 1 ]; then
				echo multiple PIDs found for given name:
				echo $PID
				echo "select one: " && read PID
			fi
		fi

		# $PID now either contains the right PID or nothing

		# save process with arguments
		PROCESS=$(ps aux | grep "$PID" | grep -v grep | tr -s " " | cut -d ' ' -f11-)

		while [ "$PID" ]; do
			if ps -p $PID > /dev/null; then
				echo "process still running"
				sleep $2
			else
				echo "process killed"
				echo "wanna restart? (y/n)? "
				read -r -n 1 ANSWER;
				if [[ $ANSWER = [Yy] ]]; then
					nohup $PROCESS & 2>/dev/null 1>/dev/null
					PID=$!
					if [ "$PID" -eq "$PID" ]; then
							echo "new PID is $PID"
					else
						>&2 echo "restarting process failed"
						exit -1
					fi
				elif [[ $ANSWER = [Nn] ]]; then
					exit 0
				fi
			fi
		done
	else
		echo second argument must be a number
	fi
elif [[ $# -gt 2 ]]; then
	echo too much arguments, try again
fi
