#!/bin/bash

# Get a list of tmux sessions
TMUX_SESSIONS=$(tmux list-sessions -F "#S")

# Iterate through each tmux session
for session in $TMUX_SESSIONS; do
	# Create a new Guake tab and name it after the tmux session
	# Note: Guake doesn't directly allow renaming tabs via command line in all versions,
	# so we set the title through tmux's option if necessary.
	guake -n $session
	guake -r $session
	#"tmux attach -t $session"

	# && tmux attach-session -t $session

	# Optional: If you need to set the Guake tab title to the session name,
	# and the version of Guake supports dynamic naming or if tmux command doesn't set it as you like,
	# you might need to use additional tools or scripts to set the Guake tab title.
done
