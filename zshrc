# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="dracula"
# ZSH_THEME="nebirhos"

# Oh-my-zsh installation path
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# HIST_STAMPS="mm/dd/yyyy"

# Plugin configuration
plugins=(
    git
    asdf
    ruby
    rails
    yarn
    bundler
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    colorize
    colored-man-pages
    tmux
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# Uncomment to set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Aliases
pgco () {
  git checkout $(git branch | eval percol) 
}

alias ta='tmux -u attach-session -t'
alias n="nvim ."
tma() {
  # List tmux sessions and use percol to select one, removing trailing colon from session names
  local session=$(tmux list-sessions | sed 's/:.*$//' | percol | awk '{print $1}')
 
  # Check if guake is installed and run it to rename the tab
  if command -v guake >/dev/null 2>&1; then
    guake -r "$session" 2>/dev/null || echo "Guake command failed. Is Guake running?"
  # else
  #   echo "Guake not found. Skipping renaming the tab."
  fi
 
  # Check if a session was selected
  if [ -z "$session" ]; then
    echo "No tmux session selected."
    return 1
  fi
  # Attach to the selected tmux session, even if already in a session
  tmux switch-client -t "$session" || tmux -u attach-session -t "$session"
}
# Load credentials
CREDENTIALS_FILE=~/dotfiles/zsh/credentials.sh
if [ -f "$CREDENTIALS_FILE" ]; then
  source "$CREDENTIALS_FILE"
else
  echo "Warning: The credentials file ($CREDENTIALS_FILE) does not exist."
fi

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load direnv
eval "$(direnv hook zsh)"

# Environment settings
export DISABLE_SPRING=true
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#ffffff'

