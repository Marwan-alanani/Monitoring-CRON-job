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
	echo -e "${YELLOW}=============================================================${NC}"
}

date_=$(date)
echo -e "${BLUE}System Monitoring Report - $date_"

annotate

title "Disk Usage"
disk_use="$(df --output=source,size,used,avail,pcent,target)"
IFS=$'\n' ;
read -d '' -r -a y <<<"$disk_use"
IFS=$' \n\t'
y_len=${#y[@]}

for (( i=0;i<${y_len};i++ ));
do
	row="${y[$i]}"
	row=($row)
	if [ $i -eq 0 ];then
		row[1]="Size"
		#echo "${row[0]}"
	fi
	before_l=$(( ${#row[@]} -2 ))
	for (( j=0;j<${#row[@]};j++ ));
	do
		if [ $i -eq 0 ] && [ $j -eq $before_l ]
		then
			printf "%s " "${row[$j]}"
			continue
		elif [ $i -ne 0 ] && [ $j -ge 1 ] && [ $j -le 3 ]
		then
			row[$j]=$(KbToGb ${row[$j]})
			row[$j]="${row[$j]}G"
		fi 
		
		printf "%-18s" "${row[$j]}"
	done
	echo ""
done

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
echo "";echo ""

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
