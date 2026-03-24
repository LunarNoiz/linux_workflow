#!/bin/bash

# Exit on error
set -e

echo "[*] Starting dotfiles installation..."

# 1. Update and install dependencies (assumes Debian/Ubuntu or Arch or Fedora)
echo "[*] Installing dependencies..."
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y neovim tmux git curl gcc ripgrep xclip python3-venv python3-pip nodejs npm unzip
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm neovim tmux git curl gcc ripgrep xclip python nodejs npm unzip
elif command -v dnf &> /dev/null; then
    sudo dnf install -y neovim tmux git curl gcc ripgrep xclip python3 nodejs npm unzip
else
    echo "[!] Unsupported package manager. Please install neovim, tmux, git, curl, gcc, ripgrep, xclip, nodejs, npm manually."
fi

# 2. Setup Directories
echo "[*] Setting up directories..."
mkdir -p ~/.config

# 3. Backup existing configs
echo "[*] Backing up existing configs if they exist..."
[ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
[ -f ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.backup.$(date +%s)
[ -d ~/.tmux ] && [ ! -L ~/.tmux ] && mv ~/.tmux ~/.tmux.backup.$(date +%s)

# 4. Create Symlinks
echo "[*] Creating symlinks..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn "$SCRIPT_DIR/nvim" ~/.config/nvim
[ -f "$SCRIPT_DIR/.tmux.conf" ] && ln -sfn "$SCRIPT_DIR/.tmux.conf" ~/.tmux.conf
[ -d "$SCRIPT_DIR/.tmux" ] && ln -sfn "$SCRIPT_DIR/.tmux" ~/.tmux

# 5. Install Tmux Plugin Manager (TPM) if missing
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "[*] Installing Tmux Plugin Manager..."
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""
echo "====================================================================="
echo "***  INSTALLATION SUCCESSFUL!  ***"
echo "====================================================================="
echo ""
echo "To finish setting up Tmux plugins:"
echo "  1. Open a new terminal and run: tmux"
echo "  2. Press your tmux prefix (usually Ctrl+b) followed by Shift+I"
echo "     (This tells TPM to fetch and install your tmux plugins)"
echo ""
echo "To finish setting up Neovim:"
echo "  1. Open: nvim"
echo "  2. Lazy.nvim will automatically download and install all plugins."
echo "====================================================================="
echo ""
