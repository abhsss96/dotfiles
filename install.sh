#!/usr/bin/env zsh
# Bootstrap script — sets up dotfiles on a new machine

set -e

DOTFILES="$HOME/dotfiles"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

info()    { echo -e "${CYAN}  → $1${RESET}" }
success() { echo -e "${GREEN}  ✓ $1${RESET}" }
warn()    { echo -e "${YELLOW}  ! $1${RESET}" }

echo ""
echo -e "${CYAN}  ┌─────────────────────────────────┐"
echo -e "  │   Dotfiles Bootstrap Installer  │"
echo -e "  └─────────────────────────────────┘${RESET}"
echo ""

# ── Symlinks ──────────────────────────────────────────────────────────────────
# Safe symlink: removes existing symlink/dir before creating to avoid circular links
safe_link() {
  local src="$1" dst="$2"
  [[ -L "$dst" ]] && rm "$dst"
  [[ -d "$dst" && ! -L "$dst" ]] && rm -rf "$dst"
  ln -s "$src" "$dst"
}

info "Symlinking zshrc..."
safe_link "$DOTFILES/zshrc" "$HOME/.zshrc"
success "~/.zshrc linked"

info "Symlinking nvim config..."
mkdir -p "$HOME/.config"
safe_link "$DOTFILES/nvim" "$HOME/.config/nvim"
success "~/.config/nvim linked"

info "Symlinking lazygit config..."
mkdir -p "$HOME/.config/lazygit"
safe_link "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
success "~/.config/lazygit/config.yml linked"

info "Symlinking tmux config..."
safe_link "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
success "~/.tmux.conf linked"

info "Symlinking tool-versions..."
safe_link "$DOTFILES/tool-versions" "$HOME/.tool-versions"
success "~/.tool-versions linked"

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "oh-my-zsh installed"
else
  success "oh-my-zsh already installed"
fi

# ── Custom zsh plugins ────────────────────────────────────────────────────────
declare -A PLUGINS=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
  [elixir]="https://github.com/gusaiani/elixir-oh-my-zsh"
)

for plugin url in "${(@kv)PLUGINS}"; do
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
  if [[ ! -d "$dir" ]]; then
    info "Installing plugin: $plugin..."
    git clone --depth=1 "$url" "$dir"
    success "$plugin installed"
  else
    success "$plugin already installed"
  fi
done

# ── Powerlevel10k ─────────────────────────────────────────────────────────────
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  success "Powerlevel10k installed"
else
  success "Powerlevel10k already installed"
fi

# ── Tools ─────────────────────────────────────────────────────────────────────

# Detect package manager
install_pkg() {
  local pkg="$1"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command -v brew &>/dev/null && brew install "$pkg" || warn "brew not found, skipping $pkg"
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y "$pkg"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "$pkg"
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm "$pkg"
  else
    warn "No supported package manager found — install $pkg manually"
  fi
}

# eza — not in apt by default, install via cargo or binary on Linux
install_eza() {
  if command -v eza &>/dev/null; then
    success "eza already installed"
    return
  fi
  info "Installing eza..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install eza
  elif command -v cargo &>/dev/null; then
    cargo install eza
  else
    # Use prebuilt binary from GitHub releases
    local url="https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
    curl -fsSL "$url" | tar xz -C /tmp && sudo mv /tmp/eza /usr/local/bin/eza
  fi
  success "eza installed"
}

# zoxide — install via script on Linux
install_zoxide() {
  if command -v zoxide &>/dev/null; then
    success "zoxide already installed"
    return
  fi
  info "Installing zoxide..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zoxide
  else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
  success "zoxide installed"
}

# fzf
install_fzf() {
  if command -v fzf &>/dev/null; then
    success "fzf already installed"
    return
  fi
  info "Installing fzf..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fzf
  else
    git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all
  fi
  success "fzf installed"
}

# bat
install_bat() {
  if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
    success "bat already installed"
    return
  fi
  info "Installing bat..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install bat
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y bat
  else
    install_pkg bat
  fi
  success "bat installed"
}

# circleci CLI
install_circleci() {
  if command -v circleci &>/dev/null; then
    success "circleci CLI already installed"
    return
  fi
  info "Installing circleci CLI..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install circleci
  else
    curl -fLSs https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/main/install.sh | sudo bash
  fi
  success "circleci CLI installed"
}

# smartthings CLI — installs under the Node version in .tool-versions
install_smartthings() {
  local required_node
  required_node=$(grep '^nodejs' "$DOTFILES/tool-versions" | awk '{print $2}')

  # Ensure the required Node version is installed via asdf
  if command -v asdf &>/dev/null; then
    if ! asdf list nodejs 2>/dev/null | grep -q "$required_node"; then
      info "Installing Node.js $required_node via asdf..."
      asdf install nodejs "$required_node"
    fi
    # Run npm install under the exact Node version from .tool-versions
    local node_bin="$HOME/.asdf/installs/nodejs/$required_node/bin"
    if [[ ! -x "$node_bin/npm" ]]; then
      warn "Node $required_node bin not found at $node_bin — skipping smartthings install"
      return
    fi
    if [[ -x "$node_bin/smartthings" ]]; then
      success "smartthings CLI already installed (Node $required_node)"
      return
    fi
    info "Installing SmartThings CLI under Node $required_node..."
    "$node_bin/npm" install -g @smartthings/cli
    success "smartthings CLI installed"
  else
    warn "asdf not found — install Node.js $required_node manually, then run: npm install -g @smartthings/cli"
  fi
}

install_eza
install_zoxide
install_fzf
install_bat
install_circleci
install_smartthings
install_pkg jq

# ── Local overrides file ──────────────────────────────────────────────────────
if [[ ! -f "$HOME/.zshrc.local" ]]; then
  info "Creating ~/.zshrc.local..."
  touch "$HOME/.zshrc.local"
  success "~/.zshrc.local created"
fi
chmod 600 "$HOME/.zshrc.local"
success "~/.zshrc.local permissions set to 600"

echo ""
success "All done! Restart your shell or run: source ~/.zshrc"
echo ""
