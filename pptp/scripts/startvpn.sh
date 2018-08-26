#/bin/sh

set -x

LOG='/var/log/startvpn.log'
LOCK='/tmp/startvpn.lock'
PID=$$
INFO="[INFO#${PID}]"
DEBUG="[DEBUG#${PID}]"
ERROR="[ERROR#${PID}]"
UPLIST=/jffs/pptp/uplist.sh

echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") startvpn.sh started" >> $LOG
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
      	exit 0
fi
      
# create the lock
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") startvpn" >> $LOCK


# /usr/sbin/pppd plugin pptp.so pptp_server hk.blockcn.net file /root/options.pptp

echo "$UPLIST add $VPNGW" >> $LOG                                                                               
#source $UPLIST add $VPNGW

