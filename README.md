# Linux Workflow Dotfiles

A modular, industry-standard Neovim and Tmux configuration.

## Installation

You can install this setup on a new machine using the following one-liner. It will clone the repository into `~/linux_workflow` and automatically run the installation script:

```bash
git clone https://github.com/JinnyLyn/linux_workflow.git ~/linux_workflow && cd ~/linux_workflow && ./install.sh
```

*(Note: Because the installation script creates symlinks pointing to the files in this repository, the files must be cloned to your local machine rather than just piped through curl.)*

## Post-Installation

### 1. API Keys & Secrets
To keep your API keys secure, `nvim/lua/secrets.lua` is intentionally ignored by Git. You must create this file locally on each new machine to use AI tools.

Create `~/.config/nvim/lua/secrets.lua` (or `~/linux_workflow/nvim/lua/secrets.lua`) and add your keys:

```lua
return {
  gemini_api_key = "YOUR_GEMINI_KEY",
  openclaw_gateway_token = "YOUR_OPENCLAW_TOKEN",
}
```

### 2. OpenCode AI Setup
Opencode is installed automatically and uses Gemini as the default model.

**Configure your API key** (required for AI features):

Option A - Shell environment (recommended):
```bash
# Add to ~/.zshrc or ~/.bashrc
export GOOGLE_API_KEY='your-gemini-api-key'
```

Option B - Local config file (ignored by Git):
```bash
# Create ~/.config/opencode/opencode.local.json
# This path is already in opencode/.gitignore
{
  "provider": {
    "google": {
      "options": {
        "apiKey": "your-gemini-api-key"
      }
    }
  }
}
```

### 3. Tmux Plugins
1. Open a new terminal and start tmux: `tmux`
2. Press your tmux prefix (usually `Ctrl+b`) followed by `Shift+I` to fetch and install your tmux plugins via TPM.

### 4. Neovim Plugins
1. Open Neovim: `nvim`
2. Lazy.nvim will automatically bootstrap and install all configured plugins.

## OpenCode Usage

### Keybindings
| Key | Action |
|-----|--------|
| `<C-a>` | Ask opencode with current selection/word |
| `<C-x>` | Open opencode command palette |
| `<C-.>` | Toggle opencode terminal |
| `go` | Add range to opencode (operator) |
| `goo` | Add current line to opencode |
| `<leader>op` | Ask with project context |
| `<leader>or` | Code review current file |
| `<leader>ox` | Load project agents (if .opencode/ exists) |
| `<leader>oi` | Initialize .opencode/ for project |

### Available Agents
- **@build** - Default agent for development
- **@plan** - Analysis without modifications
- **@code-reviewer** - Security/performance review
- **@refactorer** - Code improvement suggestions
- **@debug-assistant** - Bug investigation
- **@documentation-writer** - Technical writing
- **@error-checker** - Quality gatekeeper
- **@code-gc** - Cleanup agent-generated files
- **@ctf-exploit-generator** - CTF exploit development

### Project-Specific Setup
Initialize a `.opencode/` directory for project-specific configuration:

```bash
# In your project root
:OpencodeInitProject
```

This creates:
```
.yourproject/
├── .claude/
│   ├── OPENCODE.md      # Project rules and conventions
│   └── run-checks.sh    # Test/lint runner
├── .opencode/
│   ├── agents/          # Custom agents
│   ├── commands/        # Custom commands
│   └── prompts/         # Custom prompts
```

## Documentation
Please refer to `nvim/lua/guide.txt` for additional details and notes on navigating this workflow.