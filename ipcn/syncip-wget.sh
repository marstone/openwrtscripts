#!/bin/sh

#set -x
#ADDR='http://www.tcp5.com/addresslist/cernet.rsc
#http://www.tcp5.com/addresslist/mobile.rsc
#http://www.tcp5.com/addresslist/other.rsc
#http://www.tcp5.com/addresslist/telecom.rsc
#http://www.tcp5.com/addresslist/unicom.rsc'

ADDR='http://tcp5:2911911@www.tcp5.com/table/cernet.rsc
http://tcp5:2911911@www.tcp5.com/table/mobile.rsc
http://tcp5:2911911@www.tcp5.com/table/other.rsc
http://tcp5:2911911@www.tcp5.com/table/telecom.rsc
http://tcp5:2911911@www.tcp5.com/table/unicom.rsc'


TEMPFILE='/tmp/ipcn.tmp'
TEMPRSC='/tmp/ipcn.rsc'
IPCNFILE='ipcn'

echo "begin to sync china ip list."

touch $TEMPFILE
rm $TEMPFILE
touch $TEMPFILE

COUNT=0
ADDRESS=ADDR[0]

for ADDRESS in $ADDR
do
	echo "loading $ADDRESS..."
	wget $ADDRESS -O $TEMPRSC
	touch $TEMPRSC
	cat $TEMPRSC | grep -Eo "([0-9]+\.){3}[0-9]+[/[0-9]+]*" >> $TEMPFILE 
done

LINES=$(cat $TEMPFILE | wc | grep -Eo [0-9]+ | head -n1)

echo "got $LINES china ip records"
touch $TEMPRSC
rm $TEMPRSC

if [ $LINES -gt 2000 ]; then
	echo "copy to $IPCNFILE"
	cp $TEMPFILE $IPCNFILE
else
	echo "too little records, drop."
fi

rm $TEMPFILE
