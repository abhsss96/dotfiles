# Aliases for ls command with different options
alias ll='ls -alF' # List all files in long format, including hidden files, with type indicators
alias la='ls -A'   # List all files except '.' and '..'
alias l='ls -CF'   # List files in columns, with type indicators
alias c='chatgpt'  # Alias for chatgpt command

# Git checkout using percol for branch selection
pgco() {
  git checkout $(git branch | eval percol) # Use percol to select a branch and checkout
}

# Alias for attaching to a tmux session
alias ta='tmux -u attach-session -t' # Attach to a tmux session with UTF-8 support

# Alias for opening Neovim in the current directory
alias n="nvim ."

# Function to attach to a tmux session using percol for session selection
tma() {
  echo "Listing tmux sessions..."
  local session=$(tmux list-sessions | sed 's/:.*$//' | percol | awk '{print $1}')
  echo "Selected session: $session"

  echo "Checking if guake is installed..."
  if command -v guake >/dev/null 2>&1; then
    echo "Guake is installed. Renaming tab..."
    guake -r "$session" 2>/dev/null || echo "Guake command failed. Is Guake running?"
  fi

  echo "Checking if a session was selected..."
  if [ -z "$session" ]; then
    echo "No tmux session selected."
    return 1
  fi

  if [ -n "$TMUX" ]; then
    echo "Attaching to tmux session: $session"
    tmux switch-client -t "$session"
  else
    echo "Attaching to tmux session: $session"
    tmux -u attach-session -t "$session"
  fi
}

# Alias for editing the gh-dash configuration file
alias gdc="nvim ~/.config/gh-dash/config.yml"

# Function to manage gh-dash configuration and launch gh dash
gdash() {
  CONFIG_FILE="$HOME/.config/gh-dash/config.yml"
  CURRENT_DIR=$(pwd)
  CURRENT_FOLDER=$(basename "$PWD")

  mkdir -p "$(dirname "$CONFIG_FILE")"
  touch "$CONFIG_FILE"

  if ! grep -q "repoPaths:" "$CONFIG_FILE"; then
    echo -e "  annkissam/$CURRENT_FOLDER: $CURRENT_DIR" >>"$CONFIG_FILE"
    echo "Initialized repoPaths with current directory."
  else
    if ! grep -q "  annkissam/$CURRENT_FOLDER:" "$CONFIG_FILE"; then
      if ! grep -q "  - $CURRENT_DIR" "$CONFIG_FILE"; then
        echo "  annkissam/$CURRENT_FOLDER: $CURRENT_DIR" >>"$CONFIG_FILE"
        echo "Added $CURRENT_DIR to repoPaths."
      fi
    fi
  fi

  gh dash
}
# Alias for checking out the latest pull request and opening lazygit
alias ghr='gh pr checkout $(gh pr list --limit 1 --json number -q ".[0].number") && lazygit'

# Function to open a pull request review dashboard in tmux
pr_review_dashboard() {
  if [ -n "$TMUX" ]; then
    tmux split-window -h -p 50 "lazygit"
    tmux select-pane -U
    clear
    gdash
  else
    echo "Not in a tmux session. Starting tmux..."
    tmux new-session \; send-keys 'gdash' C-m \; split-window -v -p 50 'lazygit'
  fi
}

alias prd="pr_review_dashboard"
