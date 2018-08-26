#!/bin/sh

logger 'vpnc checker started.'

ps | grep vpnc > /tmp/checker.log

if [ $(ps | grep vpnc | grep -v checker | grep -v restart | grep -v grep | wc -l) -eq 0 ]; then
	/etc/init.d/vpnc restart;
fi
 
