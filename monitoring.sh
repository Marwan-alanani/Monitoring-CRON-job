#!/bin/bash
out=`./monitor.sh`
echo "$out" >> log
if echo "$out" | grep "Warning:" ;then
	echo "$out" | mail -s "Monitoring Report" marwan-walid1@hotmail.com
fi
