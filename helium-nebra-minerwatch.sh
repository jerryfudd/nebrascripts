#!/bin/bash

#WRITTEN BY DEDWARDS
#SCRIPT TO MONITOR NEBRA MINER STATUS


while true; do
	miner="192.168.1.4"
	name=$(basename "$0" .sh)
	now=$(date '+%H:%M:%S')
	today=$(date '+%Y-%m-%d')
	output="/tmp/"$name".log"
	
	echo > "$output"
	echo "=============================================" >> "$output"
	echo "| Miner Watch for "$today" as of "$now" |" >> "$output"
	echo "=============================================" >> "$output"
	echo >> "$output"

	if ping -c 1 "$miner" &> /dev/null; then
  		echo "Ping Check "$miner": PASS" >> "$output"
  		animal=$(curl -s http://"$miner"/json | awk -F '":' '{print $2}'  | sed 's/,"APPNAME/ /g' | tr -d '"')
		if [ -z "$animal" ]; then
			echo "Miner Check: FAIL" >> "$output"
			#sudo ssh -t root@"$miner" -p 22222 balena container restart $(balena container ps -q)
			sudo ssh -t root@"$miner" -p 22222 reboot
		else
			echo "Miner Check: "$animal"" >> "$output"
		fi
	else
  		echo "Ping Check "$miner": FAIL" >> "$output"
	fi
	echo >> "$output"
	sleep 600
done