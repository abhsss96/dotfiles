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
alias nn='nano'
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

# ── Kubernetes ─────────────────────────────────────────────────────────────────
kubelogs() {
  local namespace=$(kubectl get namespaces | eval percol | awk '{ print $1 }')
  local pod_name=$(kubectl get po --namespace=$namespace | eval percol | awk '{ print $1 }')
  kubectl logs $pod_name --namespace=$namespace --follow
}

kubessh() {
  local namespace=$(kubectl get namespaces | eval percol | awk '{ print $1 }')
  local pod_name=$(kubectl get po --namespace=$namespace | eval percol | awk '{ print $1 }')
  kubectl exec -it $pod_name --namespace=$namespace -- bash
}

# ── Tmux ───────────────────────────────────────────────────────────────────────
alias tm='tmux -u'
alias ta='tmux -u attach-session -t'
alias tl='tmux list-sessions'
alias tr='tmux source-file ~/.tmux.conf'
alias tmuxr='tmux source ~/.tmux.conf'

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

  # Rename the terminal tab at the application level (mirrors guake -r behaviour)
  if command -v guake &>/dev/null; then
    guake -r "$session" 2>/dev/null
  elif [[ -n "$ITERM_SESSION_ID" ]]; then
    osascript 2>/dev/null <<EOF
      tell application "iTerm2"
        tell current window
          tell current tab
            tell current session
              set name to "$session"
            end tell
          end tell
        end tell
      end tell
EOF
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux -u attach-session -t "$session"
  fi
}

# ── SSH ────────────────────────────────────────────────────────────────────────
alias sa='ssh-add ~/.ssh/id_rsa'

# ── AI ─────────────────────────────────────────────────────────────────────────
alias c='claude'
alias a='agent'
