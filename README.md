# Dotfiles

Personal development environment configuration for macOS and Linux.

## What's Inside

| Config | Description |
|--------|-------------|
| `zshrc` | Zsh shell config with oh-my-zsh, Powerlevel10k, and lazy plugin loading |
| `nvim/` | Neovim config built on [LazyVim](https://lazyvim.org) |
| `tmux.conf` | Tmux config with vim-style navigation |
| `zsh/` | Modular shell scripts for aliases, AI tools, welcome message, and more |

## Installation

```bash
git clone git@github.com:abhsss96/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:
- Symlink `zshrc`, `nvim`, `tmux.conf`, and `.tool-versions` to their expected locations
- Install [oh-my-zsh](https://ohmyz.sh) if not present
- Install custom zsh plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `elixir`)
- Install [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- Install CLI tools: `eza`, `zoxide`, `fzf`, `bat`, `smartthings` (via brew on macOS, apt/dnf/pacman on Linux)
- Create `~/.zshrc.local` with `chmod 600` for machine-specific secrets

## Zsh

### Shell startup time
Optimized to load in ~100ms via:
- Lazy-loading Ruby/Rails/Bundler plugins (only loads in project directories with a `Gemfile`)
- Disabled `compaudit` security check on every start
- Removed subprocess calls from PATH setup

### Modules

| File | Purpose |
|------|---------|
| `zsh/aliases.sh` | `ls`/`eza`, git, tmux, and GitHub Dash aliases |
| `zsh/ai.sh` | `debug`, `review`, `ac`, `gpt` — AI-assisted terminal tools |
| `zsh/welcome.sh` | Startup banner with date, hostname, and shell load time |
| `zsh/plugins.sh` | Auto-installs missing oh-my-zsh custom plugins on first run |
| `zsh/ruby_lazy.sh` | Lazy-loads Ruby/Rails plugins when entering a project directory |
| `zsh/credentials.sh` | API keys and secrets (gitignored — copy from `credentials.sh.example`) |

### Key aliases

| Alias | Command |
|-------|---------|
| `n` | `nvim` |
| `ll` | `eza -alF --icons --git` (or `ls -alF` fallback) |
| `lt` | `eza --tree --icons --level=2` |
| `ta` | `tmux attach-session -t` |
| `tma` | Interactive tmux session picker (fzf) |
| `prd` | PR review dashboard (lazygit + gh-dash in tmux split) |
| `debug` | Send last failed command's error to ChatGPT |
| `review` | Show git diff and optionally send to ChatGPT for review |

## Neovim

Built on [LazyVim](https://lazyvim.org) with the following customizations:

### Plugins

| Plugin | Purpose |
|--------|---------|
| [notes-nvim](https://github.com/abhsss96/notes-nvim) | Project-scoped note taking (`~/notes`) |
| `snacks.nvim` | Dashboard, notifications, and UI utilities (LazyVim default) |
| `markdown-preview.nvim` | Live markdown preview in browser |
| `colorizer.lua` | Inline color highlighting |
| `conform.nvim` | Auto-formatting |

### Language support
Ruby, Rails, Elixir, TypeScript, JSON, YAML, Docker, Markdown, ERB

### Key keymaps

| Key | Action |
|-----|--------|
| `<C-p>` | Find files (Telescope) |
| `<C-f>` | Live grep (Telescope) |
| `<leader>n*` | Notes (`no` open, `nt` today, `np` find project, `na` find all) |
| `<leader>N` | Notification history |
| `<A-↑↓←→>` | Navigate splits / tmux panes seamlessly |
| `yf` | Yank relative file path |

## Secrets & local overrides

Machine-specific config and secrets live in `~/.zshrc.local` (gitignored, never committed).
Copy the example and fill in your values:

```bash
cp zshrc.local.example ~/.zshrc.local
```

| Variable | Description |
|----------|-------------|
| `SMARTTHINGS_MONITOR_ID` | Samsung M8 device ID (from `smartthings devices`) |
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `GITHUB_TOKEN` | GitHub personal access token |
| `OPENAI_API_KEY` | OpenAI API key |

## Samsung M8 Monitor Input Switching

Controls the monitor's HDMI input via the [SmartThings CLI](https://github.com/SmartThingsCommunity/smartthings-cli).
Useful when two machines share the same monitor.

### Setup

1. Authenticate: `smartthings login`
2. Find device ID: `smartthings devices`
3. Add to `~/.zshrc.local`:
   ```bash
   export SMARTTHINGS_MONITOR_ID='your-device-id'
   ```

### Commands

| Command | Action |
|---------|--------|
| `hdmi1` | Switch to HDMI 1 |
| `hdmi2` | Switch to HDMI 2 |
| `hdmi-toggle` / `t` | Toggle between HDMI 1 and 2 (reads live state from SmartThings) |

## Requirements

- `zsh` + `git` + `curl`
- [asdf](https://asdf-vm.com) — version manager for Node, Ruby, Elixir
- [Neovim](https://neovim.io) >= 0.9
- [Tmux](https://github.com/tmux/tmux) >= 3.0
- [Homebrew](https://brew.sh) (macOS) or `apt`/`dnf`/`pacman` (Linux)
