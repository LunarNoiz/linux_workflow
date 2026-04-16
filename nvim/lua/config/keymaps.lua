local keymap = vim.keymap.set

keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Buffer navigation
keymap("n", "H", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
keymap("n", "L", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap("n", "W", ":Bdelete!<CR>", { desc = "Close Buffer" })

-- Insert mode navigation tweaks
keymap("i", "<C-u>", "<Esc>I", { noremap = true, silent = true })
keymap("i", "<C-o>", "<Esc>A", { noremap = true, silent = true })

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- Move lines
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move Line Down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move Line Up" })
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move Line Down" })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move Line Up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Window splits & resizing
keymap('n', '<leader>v', ':vsplit<CR>', { desc = 'Vertical Split' })
keymap('n', '<leader>h', ':split<CR>', { desc = 'Horizontal Split' })
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Diagnostics
keymap('n', '<leader>dt', vim.diagnostic.setloclist, { desc = '[D]iagnostic [T]oggle List' })

-- Git Status (Fugitive)
keymap('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [S]tatus' })

-- Undotree
keymap('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })


