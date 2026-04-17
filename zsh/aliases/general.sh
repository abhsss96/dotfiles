# ── Navigation ────────────────────────────────────────────────────────────────
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

# ── Editor ────────────────────────────────────────────────────────────────────
alias vim='nvim'
alias nn='nano'
alias n='nvim .'

# ── Git ───────────────────────────────────────────────────────────────────────
alias ghr='gh pr checkout $(gh pr list --limit 1 --json number -q ".[0].number") && lazygit'

# Interactive branch checkout
pgco() {
  if command -v fzf &>/dev/null; then
    git checkout $(git branch | fzf)
  elif command -v percol &>/dev/null; then
    git checkout $(git branch | percol)
  else
    echo "Install fzf or percol for interactive branch selection."
  fi
}

# Copy current git branch name to clipboard (macOS + Linux)
ygb() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || {
    echo "Not in a git repository or no branch checked out." >&2
    return 1
  }

  if [[ "$OSTYPE" == darwin* ]] && command -v pbcopy &>/dev/null; then
    printf '%s' "$branch" | pbcopy
  elif [[ -n "$WAYLAND_DISPLAY" ]] && command -v wl-copy &>/dev/null; then
    printf '%s' "$branch" | wl-copy
  elif command -v xclip &>/dev/null; then
    printf '%s' "$branch" | xclip -selection clipboard
  elif command -v xsel &>/dev/null; then
    printf '%s' "$branch" | xsel --clipboard --input
  else
    echo "No clipboard tool found. Install pbcopy (macOS), wl-copy, xclip, or xsel." >&2
    return 1
  fi

  echo "Copied: $branch"
}

# ── Tmux ──────────────────────────────────────────────────────────────────────
alias tm='tmux -u'
alias ta='tmux -u attach-session -t'
alias tl='tmux list-sessions'
alias tr='tmux source-file ~/.tmux.conf'
alias tmuxr='tmux source ~/.tmux.conf'

# Interactive tmux session attach
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

# ── Kubernetes ────────────────────────────────────────────────────────────────
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

# ── SSH ───────────────────────────────────────────────────────────────────────
alias sa='ssh-add ~/.ssh/id_rsa'

# ── AI ────────────────────────────────────────────────────────────────────────
alias c='claude'
alias a='agent'
