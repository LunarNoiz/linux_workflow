vim.api.nvim_create_autocmd("FileType", {
  pattern = "codecompanion",
  callback = function(opts)
    vim.keymap.set("n", "+", "<cmd>lua require('codecompanion').chat()<cr>", { buffer = opts.buf, desc = "New Chat" })
  end,
})
