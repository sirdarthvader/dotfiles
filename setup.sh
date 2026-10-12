#!/bin/bash
# ============================================================
# DOTFILES SETUP SCRIPT
# Run this on a new machine: ./setup.sh
# ============================================================

set -e
echo "🚀 Setting up your dev environment..."

# ── Detect OS ─────────────────────────────────────────────
OS="$(uname -s)"

# ── Install tools ─────────────────────────────────────────
if [ "$OS" = "Darwin" ]; then
  # macOS — install Homebrew if missing
  if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "📦 Installing CLI tools..."
  brew install neovim tmux fzf fd ripgrep zoxide yazi lazygit node tree-sitter-cli eza bat starship mise
  brew install --cask font-caskaydia-cove-nerd-font

elif [ "$OS" = "Linux" ]; then
  echo "📦 Installing CLI tools..."
  # Adjust for your distro — this is for Ubuntu/Debian
  sudo apt update
  sudo apt install -y tmux fzf fd-find ripgrep zoxide nodejs npm build-essential unzip

  # Neovim from the official release: apt's version is too old for LazyVim (needs >= 0.11.2)
  curl -Lo nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm nvim.tar.gz

  # lazygit (not in default repos)
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz

  echo "⚠️  yazi may need manual install on Linux — check https://yazi-rs.github.io/docs/installation"
  echo "⚠️  Install 'CaskaydiaCove Nerd Font' from https://www.nerdfonts.com/font-downloads for icons"
fi

# ── Get the directory this script lives in ────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Symlink configs ───────────────────────────────────────
echo "🔗 Linking config files..."

# Helper: back up an existing real (non-symlink) path before linking
backup_if_real() {
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    mv "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
    echo "   ↳ Backed up existing $1"
  fi
}

# Neovim — symlink the entire config directory
mkdir -p ~/.config
backup_if_real ~/.config/nvim
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim
echo "   ✓ Neovim config linked"

# Ghostty — symlink the entire config directory
mkdir -p ~/.config
backup_if_real ~/.config/ghostty
ln -sfn "$DOTFILES_DIR/ghostty" ~/.config/ghostty
echo "   ✓ Ghostty config linked"

# tmux — symlink the whole config dir (config + widget scripts) and the legacy path
backup_if_real ~/.config/tmux
ln -sfn "$DOTFILES_DIR/tmux" ~/.config/tmux
backup_if_real ~/.tmux.conf
ln -sfn "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf
echo "   ✓ tmux config + widgets linked"

# Shell config — symlink the whole zshrc
backup_if_real ~/.zshrc
ln -sfn "$DOTFILES_DIR/zsh/zshrc" ~/.zshrc
echo "   ✓ Shell config linked"

# bat — Tokyo Night theme (also used by delta)
backup_if_real ~/.config/bat
ln -sfn "$DOTFILES_DIR/bat" ~/.config/bat
bat cache --build >/dev/null
git config --global delta.syntax-theme tokyonight_night
echo "   ✓ bat theme linked"
# ── tmux plugin manager (TPM) ────────────────
# The tmux config loads plugins from ~/.tmux/plugins; clone TPM so they work.
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "📦 Installing TPM (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "   ✓ TPM installed (open tmux and press prefix + I to install plugins)"
fi
# ── Install Claude Code CLI ───────────────────────────────
if ! command -v claude &> /dev/null; then
  echo "📦 Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
fi

# ── Done! ─────────────────────────────────────────────────
echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Open nvim — plugins will auto-install on first launch"
echo "  3. Run :Copilot auth inside Neovim to sign in to GitHub Copilot"
echo "  4. Run 'claude auth' in terminal to sign in to Claude Code"
echo "  5. Open Ghostty (auto-attaches tmux), then prefix + I to install tmux plugins; use 't' or prefix + f to open a project"
echo ""
