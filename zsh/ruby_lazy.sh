# Lazy-load ruby/rails/bundler/yarn oh-my-zsh plugins
# Only activates when entering a directory with a Gemfile or .ruby-version

_ruby_plugins_loaded=0

_load_ruby_plugins() {
  if [[ $_ruby_plugins_loaded -eq 0 ]] && [[ -f Gemfile || -f .ruby-version ]]; then
    _ruby_plugins_loaded=1
    for plugin in ruby rails bundler yarn elixir; do
      local plugin_path="$ZSH/plugins/$plugin/$plugin.plugin.zsh"
      local custom_path="${ZSH_CUSTOM:-$ZSH/custom}/plugins/$plugin/$plugin.plugin.zsh"
      if [[ -f "$custom_path" ]]; then
        source "$custom_path"
      elif [[ -f "$plugin_path" ]]; then
        source "$plugin_path"
      fi
    done
  fi
}

# Hook into directory changes
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _load_ruby_plugins

# Also check on shell start in case we open directly in a project dir
_load_ruby_plugins
