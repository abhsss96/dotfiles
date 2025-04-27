# Store last command
preexec() {
  LAST_CMD="$1"
  ERROR_OUTPUT=""
}

# Override `precmd` to capture error if the last command failed
precmd() {
  if [[ $? -ne 0 && -n "$LAST_CMD" ]]; then
    ERROR_OUTPUT=$(eval "$LAST_CMD" 2>&1 >/dev/null)
  fi
}

# Alias for ChatGPT CLI debug
debug() {
  if [[ -n "$ERROR_OUTPUT" ]]; then
    chatgpt "Command: $LAST_CMD\n\nError:\n$ERROR_OUTPUT"
  else
    echo "No error to debug."
  fi
}

review() {
  # Use bat or fallback to batcat
  if command -v bat >/dev/null; then
    BAT_CMD="bat"
  elif command -v batcat >/dev/null; then
    BAT_CMD="batcat"
  else
    echo "bat is not installed."
    return 1
  fi

  # Determine the base branch
  BASE_BRANCH="main"
  if ! git show-ref --verify --quiet refs/heads/main; then
    BASE_BRANCH="master"
  fi

  # Get the diff
  DIFF=$(git diff origin/$BASE_BRANCH...HEAD)

  if [[ -z "$DIFF" ]]; then
    echo "No diff to review."
    return
  fi

  # Save diff to temp file and display using bat
  TEMP_DIFF_FILE=$(mktemp /tmp/review_diff.XXXXXX)
  echo "$DIFF" >"$TEMP_DIFF_FILE"
  echo "Showing diff in bat:"
  $BAT_CMD --paging=always "$TEMP_DIFF_FILE"

  # zsh-compatible read
  echo -n "Do you want to send this diff to ChatGPT for review? (y/n): "
  read CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    echo "Aborted."
    rm "$TEMP_DIFF_FILE"
    return
  fi

  # Get ChatGPT response and save to temp file
  TEMP_RESPONSE_FILE=$(mktemp /tmp/review_response.XXXXXX)
  chatgpt "Please review this pull request diff and suggest improvements with line numbers and file names:\n\n$DIFF" >"$TEMP_RESPONSE_FILE"

  # Display ChatGPT response using bat
  echo "ChatGPT Review:"
  $BAT_CMD --paging=always "$TEMP_RESPONSE_FILE"

  # Clean up
  rm "$TEMP_DIFF_FILE" "$TEMP_RESPONSE_FILE"
}

ac() {
  asdf shell nodejs 20.3.1
  command aicommits "$@"
}

gpt() {
  asdf shell nodejs 20.3.1
  command chatgpt "$@"
}
