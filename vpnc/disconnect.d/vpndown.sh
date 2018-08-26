#!/bin/sh

source /etc/vpnc/utils.sh
LOG='/tmp/vpnchook.log'
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") vpndown.sh started" >> $LOG
#echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") vpndown.sh started" >> $LOG2

# get lock
Lock
if [ "$LASTERR" != '' ]; then
        echo "$ERROR LASTERR=$LASTERR" >> $LOG
        exit 0
fi
                
# get oldgw & vpngw
ResolveGateways
if [ "$CNGW" == '' ] || [ "$VPNGW" == '' ]; then
	echo "$ERROR CNGW/VPNGW is empty, is the WAN disconnected?" >> $LOG
        exit 0
fi

echo "[INFO] removing the static routes"
route -n | awk '$NF ~ /$VPNDEV/{print $1,$3}' | while read x y
do
	echo "deleting $x $y" >> $LOG
	route del -net $x netmask $y
done

#echo "$INFO routing ipwhite/ipcn/ipblack..." >> $LOG
# white list
#/etc/openvpn/route.sh del $CNGW /etc/openvpn/ipwhite
# cn list
#/etc/openvpn/route.sh del $CNGW /etc/openvpn/ipcn &
# gfw list
#/etc/openvpn/route.sh add $VPNGW /etc/openvpn/ipblack
#echo "$INFO static routes added" >> $LOG

# disable forwarding
iptables -D POSTROUTING -t nat -o $VPNDEV -j MASQUERADE

# route add default gw $CNGW
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") vpndown.sh ended" >> $LOG

# release the lock                                                                                
Unlock
