#/bin/sh
LOG_FILE=/tmp/log/pptp-client1.log

echo "starting scripts/up.sh..." >> $LOG_FILE
echo $PPP_REMOTE >> $LOG_FILE
echo $PPP_LOCAL >> $LOG_FILE
echo $PPP_IFACE >> $LOG_FILE

