#!/bin/sh
# Simple script to show the cpu temp formatted to be shown in polybar
# Detect CPU type
cpu_type=$(lscpu | grep "Vendor ID:" | awk '{print $3}')

if [ "$cpu_type" == "AuthenticAMD" ]; then
	# AMD CPU
	temp=$(sensors | grep "Tctl" | sed "s/Tctl: *+//;s/°C  *//")
elif [ "$cpu_type" == "GenuineIntel" ]; then
	# Intel CPU
	temp=$(sensors | grep "Package id 0:" | sed "s/Package id 0: *+//;s/°C  *//")
fi

if [ -z "$temp" ]; then
	echo "Temperature information not available"
	exit 1
fi

# Compare and print appropriate message
if [ 1 -eq "$(echo "$temp > 70 " | bc)" ]; then
	printf "<span color='#FD807E'>󰈸 $temp°C </span>"
elif [ 1 -eq "$(echo "$temp > 50 " | bc)" ]; then
	printf "<span color='#f5a97f'>󰈸 $temp°C </span>"
elif [ 1 -eq "$(echo "$temp > 15 " | bc)" ]; then
	printf "<span color='#F3A3BC'>󰈸 $temp°C </span>"
fi
