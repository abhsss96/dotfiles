# Auto-install missing oh-my-zsh custom plugins
# Add any custom (non-bundled) plugins here with their git URLs
declare -A ZSH_CUSTOM_PLUGINS=(
  [elixir]="https://github.com/gusaiani/elixir-oh-my-zsh"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
)

for plugin in "${(@k)ZSH_CUSTOM_PLUGINS}"; do
  local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
  if [[ ! -d "$plugin_dir" ]]; then
    echo "Installing oh-my-zsh plugin: $plugin"
    git clone --depth=1 "${ZSH_CUSTOM_PLUGINS[$plugin]}" "$plugin_dir"
  fi
done
