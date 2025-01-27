#!/bin/bash


RED="\e[31m"
NC="\e[0m" # No Color
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
GRAY="\e[37m"
MAGNETA="\e[35m"
function KbToGb()
{
	divisor=$(( 1024*1024 ))
	echo $(( $1 / $divisor ))
}
function warn()
{
	echo -e "${RED}warn message${NC}"
}

function title()
{
	echo -e "${BLUE}$1:${NC}"
}

function annotate()
{
	echo -e "${GREEN}=============================================================${NC}"
}

annotate

title "Disk Usage"
disk_use="$(df --output=source,size,used,avail,pcent,target)"
echo "$disk_use"

out="$( df --output=pcent )"
i=-1
for usage in $out
do
	i=$(( $i + 1 ))
	if [ "$i" -eq 0 ];then 
		continue
	fi
	usage="${usage::-1}"
	if [ $usage -ge 60 ];then
		warn
		break
	fi
done
annotate
echo ""

annotate
title "CPU Usage"
#out=`top`
echo "$out"
annotate
echo ""
annotate
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
annotate
