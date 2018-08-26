#!/bin/sh

EXHOSTS=/root/pptp/gfwlist

echo 'uplist started.'

cat $EXHOSTS | while read line
do
	TYPE='-host'
	AORD='add'
	if [ "$1" = 'del' ]
	then
		AORD='del'
	fi
	
	SPLASH=$(echo $line | grep / -Eo)
	COMMENT=$(echo $line | grep '#' -Eo)
	IP=$(echo $line | grep "[0-9]\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]" -Eo)
	
#	echo $COMMENT

	if [ "$COMMENT" != '#' ] && [ "$IP" ]
	then

		if [ "$SPLASH" = '/' ]
		then 
			TYPE='-net'
		fi
		CMD="route $AORD $TYPE $line gateway $2"
		echo $CMD
		$CMD
	fi  	
done

