# ── Navigation ────────────────────────────────────────────────────────────────

# Use eza if available, fallback to ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -alF --icons --group-directories-first --git'
  alias la='eza -a --icons --group-directories-first'
  alias l='eza -F --icons'
  alias lt='eza --tree --icons --level=2'
else
  alias ll='ls -alF'
  alias la='ls -A'
  alias l='ls -CF'
fi

# ── Editor ─────────────────────────────────────────────────────────────────────
alias vim='nvim'
alias n='nvim .'

# ── Git ────────────────────────────────────────────────────────────────────────

# Git checkout using fzf (falls back to percol if fzf not available)
pgco() {
  if command -v fzf &>/dev/null; then
    git checkout $(git branch | fzf)
  elif command -v percol &>/dev/null; then
    git checkout $(git branch | percol)
  else
    echo "Install fzf or percol for interactive branch selection."
  fi
}

# Checkout latest PR and open lazygit
alias ghr='gh pr checkout $(gh pr list --limit 1 --json number -q ".[0].number") && lazygit'

# ── Tmux ───────────────────────────────────────────────────────────────────────
alias ta='tmux -u attach-session -t'

# Attach to a tmux session interactively
tma() {
  local session
  if command -v fzf &>/dev/null; then
    session=$(tmux list-sessions 2>/dev/null | sed 's/:.*$//' | fzf)
  elif command -v percol &>/dev/null; then
    session=$(tmux list-sessions 2>/dev/null | sed 's/:.*$//' | percol | awk '{print $1}')
  else
    echo "Install fzf for interactive session selection."
    return 1
  fi

  [[ -z "$session" ]] && return 1

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux -u attach-session -t "$session"
  fi
}

# ── GitHub Dash ────────────────────────────────────────────────────────────────
alias gdc='nvim ~/.config/gh-dash/config.yml'

gdash() {
  local config="$HOME/.config/gh-dash/config.yml"
  local folder=$(basename "$PWD")

  mkdir -p "$(dirname "$config")"
  touch "$config"

  if ! grep -q "repoPaths:" "$config"; then
    echo "  annkissam/$folder: $PWD" >>"$config"
  elif ! grep -q "annkissam/$folder:" "$config"; then
    echo "  annkissam/$folder: $PWD" >>"$config"
  fi

  gh dash
}

# PR review dashboard in tmux
pr_review_dashboard() {
  if [[ -n "$TMUX" ]]; then
    tmux split-window -h -p 50 "lazygit"
    tmux select-pane -U
    clear
    gdash
  else
    tmux new-session \; send-keys 'gdash' C-m \; split-window -v -p 50 'lazygit'
  fi
}

alias prd='pr_review_dashboard'

# ── AI ─────────────────────────────────────────────────────────────────────────
alias c='chatgpt'
