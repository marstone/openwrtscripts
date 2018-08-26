#!/bin/sh

source /etc/vpnc/utils.sh
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") vpnup.sh started" >> $LOG

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

# Google DNS and OpenDNS
#route add -host 8.8.8.8 gw $VPNGW
#route add -host 8.8.4.4 gw $VPNGW

# enable forwarding
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") enabling forwarding..." >> $LOG
iptables -A POSTROUTING -t nat -o $VPNDEV -j MASQUERADE
echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") restarting dnsmasq..." >> $LOG
/etc/init.d/dnsmasq restart

#echo "$INFO routing ipwhite/ipcn/ipblack..." >> $LOG
# white list
#/etc/openvpn/route.sh add $CNGW /etc/openvpn/ipwhite
# cn list
#/etc/openvpn/route.sh add $CNGW /etc/openvpn/ipcn &
# gfw list
#/etc/openvpn/route.sh add $VPNGW /etc/openvpn/ipblack
#echo "$INFO static routes added" >> $LOG


echo "$INFO $(date "+%d/%b/%Y:%H:%M:%S") vpnup.sh ended" >> $LOG
# release the lock
Unlock
