local ok, secrets = pcall(require, "secrets")
if ok then
  if secrets.gemini_api_key then
    vim.env.GEMINI_API_KEY = secrets.gemini_api_key
  end
  if secrets.openclaw_gateway_token then
    vim.env.OPENCLAW_GATEWAY_TOKEN = secrets.openclaw_gateway_token
  end
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.tmux_run")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

pcall(require, "custom_mappings")
