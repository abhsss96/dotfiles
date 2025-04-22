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

# Alias for ChatGPT CLI to review the current PR diff
review() {
  # Determine the base branch
  BASE_BRANCH="main"
  if ! git show-ref --verify --quiet refs/heads/main; then
    BASE_BRANCH="master"
  fi

  # Get the diff (you can change the base branch if needed)
  DIFF=$(git diff origin/$BASE_BRANCH...HEAD)

  if [[ -z "$DIFF" ]]; then
    echo "No diff to review."
    return
  fi

  echo "Diff to be reviewed:"
  echo "$DIFF"

  chatgpt "Please review this pull request diff and suggest improvements with line numbers and file names:\n\n$DIFF"
}

ac() {
  asdf shell nodejs 20.3.1
  command aicommits "$@"
}
