#!/bin/sh

set -x

CNDEV='pppoe-wan'

route -n | awk '$NF ~ /$CNDEV/{print $1,$3}' | while read x y
do
	route del -net $x netmask $y
	exit
done

route add default dev $CNDEV

