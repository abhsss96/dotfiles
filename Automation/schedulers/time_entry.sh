#!/bin/bash

# Define ticket information
TICKET_ID="Ticket #1234"
MESSAGE="Please add your time log for $TICKET_ID."

# Calculate screen center
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f1)
SCREEN_HEIGHT=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -d 'x' -f2)
WINDOW_WIDTH=300
WINDOW_HEIGHT=100

POS_X=$(($SCREEN_WIDTH / 2 - $WINDOW_WIDTH / 2))
POS_Y=$(($SCREEN_HEIGHT / 2 - $WINDOW_HEIGHT / 2))

# Display the dialog
zenity --info --text="$MESSAGE" --title="Time Log Reminder" \
	--width=$WINDOW_WIDTH --height=$WINDOW_HEIGHT \
	--window-icon="info" --ok-label="Log Time" \
	--display=:0.0
