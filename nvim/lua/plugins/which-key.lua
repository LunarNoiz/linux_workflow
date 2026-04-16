return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>c", group = "[C]ode / [C]onform" },
      { "<leader>d", group = "[D]ocument / [D]iagnostics" },
      { "<leader>f", group = "[F]ind" },
      { "<leader>g", group = "[G]it" },
      { "<leader>l", group = "[L]SP Format" },
      { "<leader>r", group = "[R]un / [R]ename" },
      { "<leader>s", group = "[S]earch" },
    })
  end,
}
