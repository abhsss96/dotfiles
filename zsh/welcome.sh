# Welcome message with date and time
function welcome_message {
  local cyan="\e[1;36m"
  local yellow="\e[1;33m"
  local green="\e[1;32m"
  local reset="\e[0m"

  echo "${cyan}==================================================="
  echo "${yellow}     Welcome to Abhishek's shell environment! ${reset}"
  echo "${cyan}==================================================="
  echo "${green}  !!! $(date) !!!${reset}"
  echo "${cyan}==================================================="
}

# Call the function
welcome_message
