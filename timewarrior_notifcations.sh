#!/bin/bash

# Calculate total time for the current day in seconds
total_time=$(timew day | grep -oP 'Tracked\s+[\d:.]+' | awk '{print $2}' | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')

# Threshold for 8 hours in seconds
eight_hours=$((9 * 3600))

# Check if total time is greater than or equal to 8 hours
if [ "$total_time" -ge "$eight_hours" ]; then
	notify-send "Time Tracking Alert" "You have reached 9 hours of work today."
fi
