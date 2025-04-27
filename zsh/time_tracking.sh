TIMEW_CACHE_FILE=~/.timew_context_cache
export TIMEW_SESSION_FILE="/tmp/timew-$(tty | tr '/' '_')"

timew_precmd() {
  # Ensure timew is installed
  if ! command -v timew >/dev/null 2>&1; then
    return
  fi

  local dir=$(pwd)
  local folder_name=$(basename "$dir")

  local tmux_session=""
  local tmux_window=""
  local cache_key=""
  local ticket_tag=""
  local branch="no-branch"

  # Avoid multiple starts in the same terminal session
  if [[ -f $TIMEW_SESSION_FILE ]]; then
    return
  fi

  # Get tmux session and window names
  if [[ -n "$TMUX" ]]; then
    tmux_session=$(tmux display-message -p '#S')
    tmux_window=$(tmux display-message -p '#W')
    cache_key="tmux|$tmux_session|$tmux_window|$dir"
  else
    tmux_session="no-session"
    tmux_window="no-window"
    cache_key="dir|$dir"
  fi

  # Check if in Git repo and get branch name
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD)

    case "$branch" in
    main | master | develop | master-staging)
      cached_ticket=$(grep "^$cache_key|" $TIMEW_CACHE_FILE 2>/dev/null | cut -d'|' -f5)
      if [[ -n $cached_ticket ]]; then
        ticket_tag="$cached_ticket"
      else
        echo -n "Enter ticket number for tracking (or press Enter to use branch name): "
        read -r ticket
        if [[ -n "$ticket" ]]; then
          ticket_tag="$ticket"
        else
          ticket_tag="$branch"
        fi
        echo "$cache_key|$ticket_tag" >>$TIMEW_CACHE_FILE
      fi
      ;;
    esac
  fi

  # Form final tag: session -> window -> folder -> branch [-> ticket/branch]
  local final_tag="${tmux_session}->${tmux_window}->${folder_name}->${branch}"

  if [[ -n "$ticket_tag" ]]; then
    final_tag="${tmux_session}->${tmux_window}->${folder_name}->${ticket_tag}"
  fi

  # Clean tag: replace spaces and pipes
  final_tag=$(echo "$final_tag" | sed 's/[ |]/_/g')

  # Exit if tag is somehow empty
  if [[ -z "$final_tag" ]]; then
    return
  fi

  # Check current active tracking
  local current_tracking=$(timew status 2>/dev/null | grep -oP '(?<=Tracking ).*' | awk '{print $1}')

  if [[ "$current_tracking" == "$final_tag" ]]; then
    # Already tracking, do nothing
    :
  elif [[ -z "$current_tracking" ]]; then
    timew start "$final_tag"
  else
    timew stop
    timew start "$final_tag"
  fi

  touch $TIMEW_SESSION_FILE
}

TRAPEXIT() {
  if [[ -f $TIMEW_SESSION_FILE ]]; then
    timew stop
    rm $TIMEW_SESSION_FILE
  fi
}

# Hook registration
autoload -Uz add-zsh-hook
add-zsh-hook precmd timew_precmd
