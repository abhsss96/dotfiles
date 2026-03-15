# Welcome message
function welcome_message {
  local reset="\e[0m"
  local bold="\e[1m"

  # Colors
  local c1="\e[38;5;39m"   # bright blue
  local c2="\e[38;5;45m"   # cyan-blue
  local c3="\e[38;5;51m"   # cyan
  local c4="\e[38;5;87m"   # light cyan
  local yellow="\e[38;5;226m"
  local green="\e[38;5;82m"
  local magenta="\e[38;5;213m"
  local orange="\e[38;5;214m"
  local white="\e[38;5;255m"
  local dim="\e[38;5;240m"

  local user="${USER:-abhishek}"
  local host="$(hostname -s)"
  local date_str="$(date '+%A, %d %B %Y')"
  local time_str="$(date '+%H:%M:%S')"

  local load_str="N/A"
  if [[ -n "$ZSH_START_TIME" ]]; then
    local ms=$(( int(($EPOCHREALTIME - $ZSH_START_TIME) * 1000) ))
    load_str="${ms}ms"
  fi

  echo ""
  echo -e "${c1}${bold}        ██╗  ██╗██╗${c2}    ████████╗██╗  ██╗███████╗██████╗ ███████╗${reset}"
  echo -e "${c1}${bold}        ██║  ██║██║${c2}    ╚══██╔══╝██║  ██║██╔════╝██╔══██╗██╔════╝${reset}"
  echo -e "${c2}${bold}        ███████║██║${c3}       ██║   ███████║█████╗  ██████╔╝█████╗  ${reset}"
  echo -e "${c3}${bold}        ██╔══██║██║${c4}       ██║   ██╔══██║██╔══╝  ██╔══██╗██╔══╝  ${reset}"
  echo -e "${c4}${bold}        ██║  ██║██║${white}       ██║   ██║  ██║███████╗██║  ██║███████╗${reset}"
  echo -e "${dim}        ╚═╝  ╚═╝╚═╝       ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝${reset}"
  echo ""
  echo -e "${dim}        ┌─────────────────────────────────────────────────────┐${reset}"
  echo -e "${dim}        │${reset}  ${white}${bold}${user}${reset}${dim} · ${reset}${green}${host}${reset}"
  echo -e "${dim}        ├─────────────────────────────────────────────────────┤${reset}"
  echo -e "${dim}        │${reset}  ${yellow}📅  ${date_str}${reset}"
  echo -e "${dim}        │${reset}  ${c2}🕐  ${time_str}${reset}"
  echo -e "${dim}        │${reset}  ${orange}⚡  Shell loaded in ${bold}${load_str}${reset}"
  echo -e "${dim}        └─────────────────────────────────────────────────────┘${reset}"
  echo ""
}

welcome_message
