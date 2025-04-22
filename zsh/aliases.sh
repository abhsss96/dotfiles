# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='chatgpt'

# Aliases
pgco() {
  git checkout $(git branch | eval percol)
}

alias ta='tmux -u attach-session -t'
alias n="nvim ."
tma() {
  # List tmux sessions and use percol to select one, removing trailing colon from session names
  echo "Listing tmux sessions..."
  local session=$(tmux list-sessions | sed 's/:.*$//' | percol | awk '{print $1}')
  echo "Selected session: $session"

  # Check if guake is installed and run it to rename the tab
  echo "Checking if guake is installed..."
  if command -v guake >/dev/null 2>&1; then
    echo "Guake is installed. Renaming tab..."
    guake -r "$session" 2>/dev/null || echo "Guake command failed. Is Guake running?"
  fi

  # Check if a session was selected
  echo "Checking if a session was selected..."
  if [ -z "$session" ]; then
    echo "No tmux session selected."
    return 1
  fi

  # Check if inside a tmux session
  if [ -n "$TMUX" ]; then
    # Inside tmux, switch client
    echo "Attaching to tmux session: $session"
    tmux switch-client -t "$session"
  else
    # Outside tmux, attach to session
    echo "Attaching to tmux session: $session"
    tmux -u attach-session -t "$session"
  fi
}

alias gdc="nvim ~/.config/gh-dash/config.yml"
gdash() {
  CONFIG_FILE="$HOME/.config/gh-dash/config.yml"
  CURRENT_DIR=$(pwd)

  CURRENT_FOLDER=$(basename "$PWD")

  # Ensure config file exists
  mkdir -p "$(dirname "$CONFIG_FILE")"
  touch "$CONFIG_FILE"

  # Check if repoPaths exists, if not, initialize it
  if ! grep -q "repoPaths:" "$CONFIG_FILEILE"; then
    echo -e "  annkissam/$CURRENT_FOLDER: $CURRENT_DIR" >>"$CONFIG_FILE"
    echo "Initialized repoPaths with current directory."
  else
    # Check if current directory is already listed
    if ! grep -q "  - $CURRENT_DIR" "$CONFIG_FILE"; then
      echo "annkissam/$CURRENT_FOLDER: $CURRENT_DIR" >>"$CONFIG_FILE"
      echo "Added $CURRENT_DIR to repoPaths."
    fi
  fi

  # Launch gh dash
  gh dash
}

alias ghr='gh pr checkout $(gh pr list --limit 1 --json number -q ".[0].number") && lazygit'

pr_review_dashboard() {
  if [ -n "$TMUX" ]; then
    # You're inside tmux, so split panes
    tmux split-window -v -p 40 "lazygit"
    tmux select-pane -U
    clear
    gh dash
  else
    echo "Not in a tmux session. Starting tmux..."
    tmux new-session \; send-keys 'gh dash' C-m \; split-window -v -p 40 'lazygit'
  fi
}
