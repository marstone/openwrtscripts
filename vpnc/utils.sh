#!/bin/sh

#set -x
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

LOG='/tmp/vpnchook.log'
#LOG='/dev/tty'
LOCK='/tmp/vpnchook.lock'
PID=$$
INFO="[INFO#${PID}]"
DEBUG="[DEBUG#${PID}]"
ERROR="[ERROR#${PID}]"
LASTERR=''

# Resolve oldgw & vpngw
ResolveGateways() {
        #Change this to your local interface
        #CNDEV=$(uci get network.wan.ifname)
	CNDEV='pppoe-wan'
	CNGW=$(ifconfig | grep $CNDEV -A1 | grep -Eo "P-t-P:([0-9.]+)" | cut -d: -f2)
	#CNGW=$(uci get network.wan.gateway)

        #provided by vpnc-script
	VPNDEV=$TUNDEV
        VPNGW=$VPNGATEWAY
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") CNDEV=$CNDEV" >> $LOG
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") CNGW=$CNGW" >> $LOG
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") VPNDEV=$VPNDEV" >> $LOG
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") VPNGW=$VPNGW" >> $LOG
}
                                                

Lock() {
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") Try to get the lock:$LOCK" >> $LOG
	for i in 1 2 3 4 5 6
	do
		if [ -f $LOCK ]; then
			echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") got $LOCK , sleep 10 secs. #$i/6" >> $LOG
			sleep 10
		else
			break
		fi
	done

	if [ -f $LOCK ]; then
		echo "$ERROR $(date "+%d/%b/%Y:%H:%M:%S") still got $LOCK , I'm aborted. Fix me." >> $LOG
		$ERROR='no lock'
		exit 0
	fi
	# create the lock
	echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") lock got." >> $LOCK
}


Unlock(){
	# release the lock
	rm -f $LOCK
}

