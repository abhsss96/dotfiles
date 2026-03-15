zmodload zsh/datetime
ZSH_START_TIME=$EPOCHREALTIME

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme configuration
ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh-my-zsh installation path
export ZSH="$HOME/.oh-my-zsh"

# Plugin configuration
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    tmux
)

# Auto-install missing custom plugins before loading oh-my-zsh
source ~/dotfiles/zsh/plugins.sh

# Skip compaudit (security check) — speeds up compinit significantly
DISABLE_COMPFIX=true

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Environment settings
export DISABLE_SPRING=true
export EDITOR='nvim'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#ffffff'

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.global-node-tools/node_modules/.bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# asdf
. "$HOME/.asdf/asdf.sh"

# direnv
eval "$(direnv hook zsh)"

# zoxide (smart cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Completions
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# Source custom configs
FILES_TO_SOURCE=(
  ~/dotfiles/zsh/aliases.sh
  ~/dotfiles/zsh/ai.sh
  ~/dotfiles/zsh/welcome.sh
  ~/dotfiles/zsh/credentials.sh
  ~/dotfiles/zsh/ruby_lazy.sh
)

for FILE in "${FILES_TO_SOURCE[@]}"; do
  if [[ -f "$FILE" ]]; then
    source "$FILE"
  else
    echo "Warning: $FILE does not exist."
  fi
done
