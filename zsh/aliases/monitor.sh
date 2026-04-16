# ── Samsung M8 Monitor Input (SmartThings) ────────────────────────────────────

if command -v smartthings &>/dev/null; then
  source "$HOME/dotfiles/scripts/monitor_input.sh" 2>/dev/null

  alias hdmi1='monitor_hdmi1'
  alias hdmi2='monitor_hdmi2'
  alias hdmi-toggle='monitor_toggle'
  alias t='monitor_toggle'
fi
