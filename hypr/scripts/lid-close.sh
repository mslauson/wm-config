#!/bin/bash

AC_STATUS=$(cat /sys/class/power_supply/AC/online)  # 1 means AC power is connected, otherwise 0
MONITOR_STATUS=$(xrandr --query | grep 'HDMI-1 connected') # Replace HDMI-1 with your external monitor's id

if [[ "$AC_STATUS" -eq 1 && -n "$MONITOR_STATUS" ]]; then
    swaymsg output eDP-1 disable  # Replace eDP-1 with your laptop's internal display's id
else
    systemctl suspend
fi
