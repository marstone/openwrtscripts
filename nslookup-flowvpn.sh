#!/bin/ash
APP='[FLOWVPN] '

#VPN='enc.tw.flow.host'
#VPN='tw.flow.host'
#VPN='ph.flow.host'
VPN='kr.flow.host'
#VPN='us.flow.host'
#VPN='dc4.kr.flow.host'

IFACE='l2tp-flowvpn'

[ "$1" == "-f" ] && {
	echo $APP'-f specified, ifdown first'
	ifdown flowvpn
	sleep 2
}

[ $(ifconfig | grep $IFACE | wc -l) -gt 0 ] && {
	echo $APP'flowvpn looks fine, exit.'
	exit
}

echo $APP'flowvpn is dead, start to revive ...'

NGW=$(route -n | grep -E "^0.0.0.0")

[ -e $NGW ] && {
	echo $APP"no default gateway, add default 192.168.200.1 ..."
	ip route add default via 192.168.200.1
}

echo $APP'nslooking-up new IP ...'

NIP=$(nslookup $VPN | grep 'Address 1' | grep -Eo '\d+.\d+.\d+.\d+')

[ -e $NIP ] && {
	echo $APP"nslookup ($VPN) failed, exit."
	exit
}

echo $APP"new IP got:[$NIP]($VPN), saving to /etc/hosts ..."
sed -Ei "s/([0-9.]{7,15}) flowvpn/$NIP flowvpn/g" /etc/hosts

echo $APP'restarting flowvpn ...'
ifup flowvpn

TICK=11
while [  $(ifconfig | grep $IFACE | wc -l) -eq 0 ] && [ $TICK -gt 0 ]
do 
	TICK=$((TICK-1)); sleep 1; 
	echo $APP"wait $TICK seconds & check if flowvpn started ..."
done
[ $(ifconfig | grep l2tp-flowvpn | wc -l) -eq 0 ] && {
	echo $APP'ifup called, but seems not work.'
}

echo $APP'done'
