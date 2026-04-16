#!/usr/bin/env bash
# Control Samsung M8 monitor input via SmartThings CLI
# Requires: smartthings CLI + SMARTTHINGS_MONITOR_ID env var set in ~/.zshrc.local

_smartthings_cmd() {
  local st_bin="$HOME/.asdf/installs/nodejs/24.13.0/bin/smartthings"
  if [[ -x "$st_bin" ]]; then
    "$st_bin" "$@"
  else
    command smartthings "$@"
  fi
}

_monitor_check() {
  if ! _smartthings_cmd --version &>/dev/null; then
    echo "smartthings CLI not found." >&2
    echo "Run: ~/.asdf/installs/nodejs/24.13.0/bin/npm install -g @smartthings/cli" >&2
    return 1
  fi
  if [[ -z "$SMARTTHINGS_MONITOR_ID" ]]; then
    echo "SMARTTHINGS_MONITOR_ID is not set." >&2
    echo "Run: smartthings devices   → find your M8 device ID" >&2
    echo "Then add to ~/.zshrc.local:  export SMARTTHINGS_MONITOR_ID='<id>'" >&2
    return 1
  fi
}

monitor_hdmi1() {
  _monitor_check || return 1
  echo "Switching to HDMI 1..."
  _smartthings_cmd devices:commands "$SMARTTHINGS_MONITOR_ID" 'main:mediaInputSource:setInputSource("HDMI1")' \
    && echo "HDMI1" > "$HOME/.monitor_input_state"
}

monitor_hdmi2() {
  _monitor_check || return 1
  echo "Switching to HDMI 2..."
  _smartthings_cmd devices:commands "$SMARTTHINGS_MONITOR_ID" 'main:mediaInputSource:setInputSource("HDMI2")' \
    && echo "HDMI2" > "$HOME/.monitor_input_state"
}

monitor_toggle() {
  _monitor_check || return 1
  local state_file="$HOME/.monitor_input_state"
  local current
  current=$(cat "$state_file" 2>/dev/null)

  if [[ "$current" == "HDMI1" ]]; then
    monitor_hdmi2
  else
    monitor_hdmi1
  fi
}

# Allow running directly: ./monitor_input.sh [hdmi1|hdmi2|toggle]
case "${1:-}" in
  hdmi1)  monitor_hdmi1 ;;
  hdmi2)  monitor_hdmi2 ;;
  toggle) monitor_toggle ;;
  *)
    echo "Usage: $0 [hdmi1|hdmi2|toggle]"
    echo "  or source this file and call monitor_hdmi1 / monitor_hdmi2 / monitor_toggle"
    ;;
esac
