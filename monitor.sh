#!/bin/bash -x

# check for given PID/name
if [ "$1" -eq "$1" ] 2>/dev/null; then
	echo "using PID"
	PID=$(echo $1)
else
	echo "using process name"
	PID=$(ps aux | pgrep $1)
	NUMBER=$(echo "$PID" | wc -l)
	if [ $NUMBER -gt 1 ]; then
		echo "multiple PIDs found for given name:"
		echo "$PID"
		echo "select one: " && read PID
	fi
fi

# $PID now either contains the right PID or nothing

# save process with arguments
PROCESS=$(ps aux | grep "$PID" | grep -v grep | tr -s " " | cut -d ' ' -f11-)


while [ "$PID" ]; do
	NUMBER=$(ps aux | grep $PID | grep -v grep | wc -l)
	if [ "$NUMBER" -gt "0" ]; then
		echo "process still running"
		sleep $2
	else
		echo "process killed"
		echo "wanna restart? (y/n)? "

		while read -r -n 1 -s ANSWER; do
			if [[ $ANSWER = [Yy] ]]; then
				#PID=$(echo "$PROCESS & $!")
				echo "$PROCESS &"
				PID=$!
				if [ -z "$PID" ]; then
					>&2 echo "restarting process failed"
					exit 0
				fi
			elif [[ $ANSWER = [Nn] ]]; then
				exit 0
			fi
			break
		done
	fi
done
