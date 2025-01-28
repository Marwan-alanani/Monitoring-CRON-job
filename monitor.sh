#!/bin/bash


RED="\e[31m"
NC="\e[0m" # No Color
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
GRAY="\e[37m"
MAGNETA="\e[35m"

function warn()
{
	echo -e "${RED}Warning: $1 is above 80% usage${NC}"
}

function title()
{
	echo -e "${BLUE}$1:${NC}"
}

function annotate()
{
	echo -e "${YELLOW}=============================================================${NC}"
}
send_mail=0
date_=$(date)
echo -e "${BLUE}System Monitoring Report - $date_"

annotate

title "Disk Usage"
disk_use="$(df --output=source,size,used,avail,pcent,target -h)"
echo "$disk_use"
sources="$(df --output=source -h)"
sources=($sources)
percentages="$(df --output=pcent -h)"
percentages=($percentages)
i=0
for percent in "${percentages[@]}"
do
	percent=${percent::-1}
	if [ $i -gt 0 ] && [ $percent -ge 80 ]
	then
		warn "${sources[$i]}"
	fi
	i=$(( "$i" + 1 ))
done




# i need to fix this
title "CPU Usage"
#out=`top`
echo "$out"
echo "";echo ""
title "Memory Usage"
out=$(free | awk 'NR==2 {print $2,$3,$4}')
arr=($out)
total=$(( ${arr[0]} ))
total=$( KbToGb $total ) 
used=${arr[1]}
used=$( KbToGb $used )
free=${arr[2]}
free=$( KbToGb $free )
printf "Total Memory:${total}GB\nUsed Memory:${used}GB\nFree Memory:${free}GB\n"
echo "";echo ""
