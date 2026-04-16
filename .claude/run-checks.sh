#!/bin/bash
# run-checks.sh

set -e

echo "Running dotfiles syntax checks..."

# Check bash scripts syntax
echo "Checking bash scripts..."
for script in bin/* install.sh; do
    if [ -f "$script" ] && ! [ -d "$script" ]; then
        bash -n "$script"
    fi
done
echo "Bash syntax OK"

# Check Lua syntax using Neovim
echo "Checking Lua syntax..."
nvim --headless -c "lua for _, f in ipairs(vim.fn.glob('nvim/lua/**/*.lua', true, true)) do local chunk, err = loadfile(f); if not chunk then print('Error in '..f..': '..err); os.exit(1) end end; print('Lua syntax OK'); os.exit(0)"

# Verify opencode directory rename
if [ -d "nvim/lua/opencode" ]; then
    echo "Error: nvim/lua/opencode directory still exists. It should be renamed to nvim/lua/oc_harness."
    exit 1
fi

echo "All checks passed successfully."
exit 0
