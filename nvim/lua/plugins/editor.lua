return {
  {
    'nvim-telescope/telescope.nvim',
    branch = 'master', 
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim', 'bash', 'markdown', 'markdown_inline', 'java', 'json', 'yaml', 'toml', 'asm' },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, 
            keymaps = {
              ["af"] = "@function.outer", 
              ["if"] = "@function.inner", 
              ["ac"] = "@class.outer",    
              ["ic"] = "@class.inner",    
            },
          },
        },
      }
    end,
  },
  {
    'mbbill/undotree',
    config = function()
      vim.g.undotree_WindowLayout = 3
    end
  },
  { 'preservim/vimux' },
  { 'lambdalisue/suda.vim' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-commentary' },
  { 'moll/vim-bbye' },
  { 'windwp/nvim-autopairs', event = "InsertEnter", config = true },
  {
    'christoomey/vim-tmux-navigator',
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t" } },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t" } },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t" } },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" } },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "t" } },
    }
  },
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function() 
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>c", group = "[C]ode" },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>g", group = "[G]it" },
        { "<leader>h", group = "Git [H]unk" },
        { "<leader>r", group = "[R]un / [R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>l", group = "[L]SP / [L]anguage" },
        { "<leader>a", group = "[A]I / CodeCompanion" },
      })
    end,
  },
}
