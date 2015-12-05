#!/bin/bash
# +-------------------------------------------------------------+
# | this script looks throught the firefox-cookies and allows	|
# | searching for certain hosts/host patterns			|
# |								|
# | USAGE:							|
# | ./cookies.sh [host|hostpattern] <host or pattern>		|
# | EXAMPLE:							|
# | ./cookies.sh host github.io					|
# +-------------------------------------------------------------+

USERPROFILE=$(find ~/.mozilla/firefox -name *default)

if [[ $1 == host ]]; then
	COOKIES=$(sqlite3 $USERPROFILE/cookies.sqlite "select * from moz_cookies where host = '$2'")
elif [[ $1 == hostpattern ]]; then
	# not entirely sure what hostname patterns are / how they are used... therefore using like
        COOKIES=$(sqlite3 $USERPROFILE/cookies.sqlite "select * from moz_cookies where host like '%$2%'")
else
	echo "first argument not valid!"
	exit -1
fi

#looked up .schema of the DB
#CREATE TABLE moz_cookies (id INTEGER PRIMARY KEY, baseDomain TEXT, appId INTEGER DEFAULT 0, inBrowserElement INTEGER DEFAULT 0, name TEXT, value TEXT, host TEXT, path TEXT, expiry
#INTEGER, lastAccessed INTEGER, creationTime INTEGER, isSecure INTEGER, isHttpOnly INTEGER,  ...

CNT=0
for COOKIE in $COOKIES; do
	echo -e "ID:\t\t\t$(echo $COOKIE | cut -d '|' -f1)"
	echo -e "BASE DOMAIN:\t\t$(echo $COOKIE | cut -d '|' -f2)"
	echo -e "APP ID:\t\t\t$(echo $COOKIE | cut -d '|' -f3)"
	echo -e "IN BROWSER ELEMENT:\t$(if [[ $(echo $COOKIE | cut -d '|' -f4) == 1 ]]; then echo yes; else echo no; fi)"
	echo -e "NAME:\t\t\t$(echo $COOKIE | cut -d '|' -f5)"
	echo -e "VALUE:\t\t\t$(echo $COOKIE | cut -d '|' -f6)"
	echo -e "HOST:\t\t\t$(echo $COOKIE | cut -d '|' -f7)"
	echo -e "PATH:\t\t\t$(echo $COOKIE | cut -d '|' -f8)"
	echo -e "EXPIRES:\t\t$(date -d @$(echo $COOKIE | cut -d '|' -f9))"
        echo -e "LAST ACCESS:\t\t$(date -d @$(echo $COOKIE | cut -d '|' -f10))"
        echo -e "CREATED:\t\t$(date -d @$(echo $COOKIE | cut -d '|' -f11))"
	echo -e "IS SECURE:\t\t$(if [[ $(echo $COOKIE | cut -d '|' -f12) == 1 ]]; then echo yes; else echo no; fi)"
	echo -e "HTTP ONLY:\t\t$(if [[ $(echo $COOKIE | cut -d '|' -f13) == 1 ]]; then echo yes; else echo no; fi)"
	echo
	let CNT++
done
echo "number of matching cookies: $CNT"
