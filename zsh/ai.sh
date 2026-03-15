# Store last command and exit code safely — no re-running on failure
preexec() {
  LAST_CMD="$1"
}

precmd() {
  LAST_EXIT=$?
}

# Manually invoke to debug the last failed command
debug() {
  if [[ ${LAST_EXIT:-0} -ne 0 && -n "$LAST_CMD" ]]; then
    echo "Re-running to capture error: $LAST_CMD"
    local error_output
    error_output=$(eval "$LAST_CMD" 2>&1 >/dev/null)
    chatgpt "Command: $LAST_CMD\n\nError:\n$error_output"
  else
    echo "No error to debug."
  fi
}

# Review git diff with ChatGPT
review() {
  if command -v bat &>/dev/null; then
    local BAT_CMD="bat"
  elif command -v batcat &>/dev/null; then
    local BAT_CMD="batcat"
  else
    echo "bat is not installed."
    return 1
  fi

  local base_branch="main"
  git show-ref --verify --quiet refs/heads/main || base_branch="master"

  local diff=$(git diff origin/$base_branch...HEAD)
  [[ -z "$diff" ]] && echo "No diff to review." && return

  local tmp_diff=$(mktemp /tmp/review_diff.XXXXXX)
  echo "$diff" >"$tmp_diff"
  $BAT_CMD --paging=always "$tmp_diff"

  echo -n "Send to ChatGPT for review? (y/n): "
  read CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    rm "$tmp_diff"
    return
  fi

  local tmp_response=$(mktemp /tmp/review_response.XXXXXX)
  chatgpt "Please review this pull request diff and suggest improvements with line numbers and file names:\n\n$diff" >"$tmp_response"
  $BAT_CMD --paging=always "$tmp_response"

  rm "$tmp_diff" "$tmp_response"
}

# AI commit — uses project's node version via asdf
ac() {
  command aicommits "$@"
}

gpt() {
  command chatgpt "$@"
}
