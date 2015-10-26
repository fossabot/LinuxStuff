#!/bin/bash
# +-------------------------------------------------------------+
# | this script allows for automatic backup of all files in a	|
# | chosen directory, that have been modified in the last 24	|
# | hours. the files are compressed into a .tar.bz2 archive	|
# | which is named using a current timestamp and is stored in	|
# | the current working folder.					|
# |								|
# | USAGE:							|
# | ./backup.sh <directory>					|
# +-------------------------------------------------------------+

exec 2>/dev/null # because fuck errors

if [[ $# = 0 ]]; then
	echo "no folder for backup supplied, try again"
	exit -1
elif [[ $# = 1 ]]; then
	echo -e "$0 is running:\n";
	tar cfvj bak_files_$(date +"%Y%m%d%H%M%S").tar.bz2 $(find $1 -type f -mtime -1)
	echo -e "\ndone"
elif [[ $# -gt 1 ]]; then
	echo "too many arguments, try again"
	exit -1
fi
