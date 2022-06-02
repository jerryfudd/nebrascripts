#!/bin/bash

name=$(basename "$0" .sh)
time=$(date '+%H%M%S')
date=$(date '+%y%m%d')
now=$(date '+%H:%M:%S')
today=$(date '+%Y-%m-%d')


### INSTRUCTIONS ###

### *) SCRIPT RUNS FROM HOST MACHINE, NOT MINER ITSELFS AND ASSUMES YOU HAVE SUCESSFUL SSH ACCESS
### *) SCRIPT ASSUMES LOCAL ROOT USER PUBLIC KEY HAS BEEN REGISTERED ON MINER - IF NOT REMOVE sudo FROM LINE STARTING 'sudo ssh -t root@"$miner" -p 22222......'

### 1) MINER IP ADDRESS i.e. miner="192.168.1.4"
miner="192.168.1.4"

### 2) LOCATION ON MINER FOR CONSOLE.LOG FILES i.e. location="/mnt/data/docker/volumes/1804676_miner-log/_data"
location="/mnt/data/docker/volumes/1804676_miner-log/_data"

### 3) OUTPUT PATH AND FILE NAME i.e. output="/home/pi/$name-$date-$time.log' (LEAVE OUTPUT TO output="/tmp/$name.log" TO JUST OUTPUT TO SCREEN)
### $name = script name
### $date = short date format
### $time = short time format
output="/tmp/$name.log"


sudo ssh -t root@"$miner" -p 22222 grep "RSSI" "$location/console.log*" | sed 's:.*/::' | cut --complement -d' ' -f3,4,5 | cut --complement -d':' -f1 > "/tmp/$name.tmp"
echo > "$output"
echo "===================================================" >> "$output"
echo "| Beacons Dectected for "$today" as of "$now" |" >> "$output"
echo "===================================================" >> "$output"
echo >> "$output"
sort -r "/tmp/$name.tmp" | grep "$today" >> "$output"
cat "/tmp/$name.tmp" | grep "$today" | wc -l >> "$output"
cat "$output"
echo
/usr/bin/find "$output" -type f -daystart -mtime +7 -delete


### EXAMPLE OUTPUT ###
### ===================================================
### | Beacons Dectected for 2022-05-29 as of 17:17:54 |
### ===================================================
### 
### 2022-05-29 15:33:13.065 sending witness at RSSI: -113, Frequency: 867.5, SNR: -13.2
### 2022-05-29 14:41:30.662 sending witness at RSSI: -112, Frequency: 867.7, SNR: -20.0
### 2022-05-29 13:34:21.457 sending witness at RSSI: -113, Frequency: 867.3, SNR: -15.2
### 2022-05-29 06:30:26.583 sending witness at RSSI: -112, Frequency: 867.7, SNR: -13.8
### 2022-05-29 05:24:14.166 sending witness at RSSI: -116, Frequency: 867.1, SNR: -18.5
### 2022-05-29 03:46:57.037 sending witness at RSSI: -115, Frequency: 867.1, SNR: -10.5
### 2022-05-29 01:48:37.694 sending witness at RSSI: -115, Frequency: 867.3, SNR: -15.8
### 2022-05-29 00:55:23.900 sending witness at RSSI: -116, Frequency: 867.1, SNR: -12.2
### 2022-05-29 00:17:40.651 sending witness at RSSI: -115, Frequency: 867.9, SNR: -10.5
### 9