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

# 1.5. Install opencode if not present
if ! command -v opencode &> /dev/null; then
    echo "[*] Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash
else
    echo "[*] opencode already installed"
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

# Ensure .config/opencode exists before symlinking
mkdir -p ~/.config/opencode/profiles/default
[ -d "$SCRIPT_DIR/opencode/agent" ] && ln -sfn "$SCRIPT_DIR/opencode/agent" ~/.config/opencode/agent
[ -d "$SCRIPT_DIR/opencode/plugin" ] && ln -sfn "$SCRIPT_DIR/opencode/plugin" ~/.config/opencode/plugin
[ -d "$SCRIPT_DIR/opencode/skills" ] && ln -sfn "$SCRIPT_DIR/opencode/skills" ~/.config/opencode/skills

# Global AGENTS.md (Root and Default Profile for absolute priority)
[ -f "$SCRIPT_DIR/opencode/AGENTS.md" ] && ln -sfn "$SCRIPT_DIR/opencode/AGENTS.md" ~/.config/opencode/AGENTS.md
[ -f "$SCRIPT_DIR/opencode/AGENTS.md" ] && ln -sfn "$SCRIPT_DIR/opencode/AGENTS.md" ~/.config/opencode/profiles/default/AGENTS.md

[ -f "$SCRIPT_DIR/opencode/opencode.json" ] && ln -sfn "$SCRIPT_DIR/opencode/opencode.json" ~/.config/opencode/opencode.json
[ -f "$SCRIPT_DIR/opencode/package.json" ] && ln -sfn "$SCRIPT_DIR/opencode/package.json" ~/.config/opencode/package.json

# Symlink the entire opencode-harness directory for oc-init to find templates/hooks
[ -d "$SCRIPT_DIR/opencode-harness" ] && ln -sfn "$SCRIPT_DIR/opencode-harness" ~/.config/opencode/harness


# 5. Install Tmux Plugin Manager (TPM) if missing

if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "[*] Installing Tmux Plugin Manager..."
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 6. Setup Opencode Harness Framework
echo "[*] Setting up Opencode Harness Framework..."
chmod +x "$SCRIPT_DIR/bin/oc-init" "$SCRIPT_DIR/bin/oc-do" "$SCRIPT_DIR/bin/oc-gc" 2>/dev/null || true

# Add bin to PATH in bashrc/zshrc
for rc in ~/.bashrc ~/.zshrc; do
    if [ -f "$rc" ]; then
        if ! grep -q "$SCRIPT_DIR/bin" "$rc"; then
            echo "export PATH=\"$SCRIPT_DIR/bin:\$PATH\"" >> "$rc"
            echo "[*] Added $SCRIPT_DIR/bin to $rc"
        fi
    fi
done

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
echo ""
echo "To configure opencode API key (required for AI features):"
echo "  Add to your shell profile (~/.zshrc or ~/.bashrc):"
echo "    export GOOGLE_API_KEY='your-gemini-api-key'"
echo ""
echo "  Or create ~/.config/opencode/opencode.local.json:"
echo '    { "provider": { "google": { "options": { "apiKey": "your-key" } } } }'
echo ""
echo "====================================================================="
echo ""
