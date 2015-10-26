#!/bin/bash
exec 2>/dev/null # because fuck errors

UNAMES=$(cat /etc/passwd | cut -d ':' -f1)
UIDS=$(cat /etc/passwd | cut -d ':' -f3)

UNAME_FOUND=$( echo "$UNAMES" | grep -cim1 -Fx $1)
UID_FOUND=$( echo "$UIDS" | grep -cim1 -Fx $1)

if [ $UNAME_FOUND == 1 ]; then
	echo -e "\tfound user, printing details"
	ID=$(cat /etc/passwd | grep $1 | cut -d ':' -f3)
elif [ $UID_FOUND == 1 ]; then
	echo -e "\tfound user-id, printing details"
	ID=$1
else
	echo -e "\tuser(id) not found - quitting"
	exit -1
fi

USERINFO=$(awk -F":" 'int($3)=='"$ID"'' /etc/passwd)
echo -e "\tUSERNAME:\t$(echo $USERINFO | cut -d ':' -f1)"
echo -e "\tPW SET:\t\t$(if [[ $(echo $USERINFO | cut -d ':' -f2) == x ]]; then echo yes; else echo no; fi)"
echo -e "\tUSER-ID:\t$(echo $USERINFO | cut -d ':' -f3)"
echo -e "\tGROUP-ID:\t$(echo $USERINFO | cut -d ':' -f4)"
echo -e "\tUSER ID INFO:\t$(echo $USERINFO | cut -d ':' -f5)"
HOMEDIR=$(echo $USERINFO | cut -d ':' -f6)
echo -e "\tHOME DIR:\t$HOMEDIR"
echo -e "\tHOMEDIR FILES:\t$(find $HOMEDIR -type f | wc -l)"
echo -e "\tHOMEDIR SIZE:\t$(du -sh $HOMEDIR | cut -d$'\t' -f1)"
echo -e "\tSHELL:\t\t$(echo $USERINFO | cut -d ':' -f7)"
