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
report=""
send_mail=0
report+="\n\n"
date_=$(date)
report+="${BLUE}System Monitoring Report - $date_\n"
report+="${YELLOW}=============================================================${NC}\n"


add=`title "Disk Usage"`
report+=$add
report+="\n"
disk_use="$(df --output=source,size,used,avail,pcent,target -h)"
report+="$disk_use"
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
		add=`warn "${sources[$i]}"` 
		send_mail=1
		report+="\n"
		report+=$add
	fi
	i=$(( $i + 1 ))
done



report+="\n\n"

add=`title "CPU Usage"`
report+=$add
report+="\n"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
bool=$(echo "$cpu_usage >= 80" | bc) 
report+="Current CPU Usage: "$cpu_usage"%"
if [ "$bool"  -eq "1" ] ; then
	report+="\n"
	report+="${RED}Warning:CPU usage exceeds 80%${NC}"
	send_mail=1
fi
report+="\n\n"

add=`title "Memory Usage"`
report+="$add"
report+="\n"
out=$(free -h | awk 'NR==2 {print $2,$3,$4}')
arr=($out)
total=${arr[0]}
used=${arr[1]}
free=${arr[2]}
report+="Total Memory:${total}\nUsed Memory:${used}\nFree Memory:${free}"
report+="\n\n"
add=`title "Top 5 Memory-Consuming Proccesses"`
report+=$add
report+="\n"
out="$(top -n 1 -b -o '%MEM' | awk 'NR==7,NR==12 {print $1,$2,$10,$12}')"
report+="$out"
report+="\n\n"
echo -e "$report"

if [ $send_mail -eq 1 ];then
	echo "$report" | mail -s "Monitoring Report" marwan-walid1@hotmail.com
fi

