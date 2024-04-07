#!/bin/bash

# Prompt for ticket number
TICKET=$(zenity --entry --title="Time Log Entry" --text="Enter the ticket number:")

if [ -z "$TICKET" ]; then
	zenity --error --text="No ticket number entered. Exiting."
	exit 1
fi

# Check if there is an ongoing task
CURRENT_TASK=$(timew)

if [[ $CURRENT_TASK == *"There is no active time tracking."* ]]; then
	zenity --info --text="No current task is being tracked. Starting task for Ticket #$TICKET."
	# Uncomment the next line to start tracking the new task with TimeWarrior
	# timew start "Ticket #$TICKET"
else
	zenity --info --text="Current Task: $CURRENT_TASK"
	# If you want to stop the current task and start a new one for the entered ticket, you can uncomment the following lines:
	# timew stop
	# timew start "Ticket #$TICKET"
fi
