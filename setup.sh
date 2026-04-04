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
  brew install neovim tmux fzf fd ripgrep zoxide yazi lazygit node

elif [ "$OS" = "Linux" ]; then
  echo "📦 Installing CLI tools..."
  # Adjust for your distro — this is for Ubuntu/Debian
  sudo apt update
  sudo apt install -y neovim tmux fzf fd-find ripgrep zoxide nodejs npm

  # lazygit (not in default repos)
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz

  echo "⚠️  yazi may need manual install on Linux — check https://yazi-rs.github.io/docs/installation"
fi

# ── Get the directory this script lives in ────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Symlink configs ───────────────────────────────────────
echo "🔗 Linking config files..."

# Neovim
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
echo "   ✓ Neovim config linked"

# tmux
ln -sf "$DOTFILES_DIR/tmux.conf" ~/.tmux.conf
echo "   ✓ tmux config linked"

# Shell config — append our additions if not already present
SHELL_RC="$HOME/.zshrc"
if [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

# Add EDITOR setting if not present
if ! grep -q 'export EDITOR="nvim"' "$SHELL_RC" 2>/dev/null; then
  echo '' >> "$SHELL_RC"
  echo '# ── Added by dotfiles setup ──' >> "$SHELL_RC"
  echo 'export EDITOR="nvim"' >> "$SHELL_RC"
  echo 'alias vim="nvim"' >> "$SHELL_RC"
  echo 'alias v="nvim"' >> "$SHELL_RC"
  echo "   ✓ Shell config updated"
fi

# Add zoxide init if not present
if ! grep -q 'eval "$(zoxide init' "$SHELL_RC" 2>/dev/null; then
  echo 'eval "$(zoxide init zsh)"' >> "$SHELL_RC"
  echo "   ✓ Zoxide init added"
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
echo "  1. Restart your terminal (or run: source $SHELL_RC)"
echo "  2. Open nvim — plugins will auto-install on first launch"
echo "  3. Run :Copilot auth inside Neovim to sign in to GitHub Copilot"
echo "  4. Run :MasonInstall prettier inside Neovim for formatting"
echo "  5. Run 'claude auth' in terminal to sign in to Claude Code"
echo "  6. Start tmux with: tmux new-session -s work"
echo ""
