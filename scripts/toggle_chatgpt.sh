#!/bin/bash
# NOTE: Idea is to map F10 key to toggle chat gpt in any workspace ubuntu
# Replace 'your_application' with the actual application command or window title
# Run setup.sh before setting up this in keyboard shortcuts
# Make sure that xdotools and wmctrl is installed in the system.

# TODO:Add script to map this script with shortcut key

APPLICATION="Ubuntu Toggle ChatGPT Application"
# Try to find the window; adjust the grep command as needed
WINDOW_ID=$(xdotool search --name "$APPLICATION")

if [ -z "$WINDOW_ID" ]; then
	# If the application is not found, launch it
	chatgpt-desktop &
else
	# If found, check if it is currently active
	if xdotool getwindowfocus -f | grep -q "$WINDOW_ID"; then
		# If it is active, minimize
		xdotool windowminimize $WINDOW_ID
		# wmctrl -ir "$WINDOW_ID" -b add,hidden
	else
		# If not active, bring to front
		wmctrl -ia "$WINDOW_ID"
	fi
fi
