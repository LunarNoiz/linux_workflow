return {
  {
    'ravitemer/mcphub.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
        auto_approve = false,
        on_ready = function()
          vim.notify("MCPHub Started!", vim.log.levels.INFO)
        end,
      })
    end
  },
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {
        server = {
          port = nil,
          start = function()
            require("opencode.terminal").open("opencode --port", {
              split = "right",
              width = math.floor(vim.o.columns * 0.35),
            })
          end,
          stop = function()
            require("opencode.terminal").toggle("opencode --port", {
              split = "right",
              width = math.floor(vim.o.columns * 0.35),
            })
          end,
        },
        lsp = {
          enabled = true,
          filetypes = nil,
        },
      }

      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode…" })

      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, { desc = "Add range to opencode", expr = true })

      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "Scroll opencode up" })

      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "Scroll opencode down" })

      require("oc_harness.context")
      require("oc_harness.project_init")

      local ctx = require("oc_harness.context")

      vim.keymap.set("n", "<leader>op", function()
        local project_ctx = ctx.get_project_context()
        require("opencode").ask("@project: " .. project_ctx)
      end, { desc = "Ask opencode with project context" })

      vim.keymap.set("n", "<leader>or", function()
        require("opencode").ask("@code-reviewer Review the current file")
      end, { desc = "Code review with code-reviewer agent" })

      vim.keymap.set("n", "<leader>oi", function()
        local templates = {"generic", "python", "web", "c_cpp", "go"}
        vim.ui.select(templates, { prompt = "Select Harness Template:" }, function(choice)
          if choice then
            require("oc_harness.project_init").init_project(choice)
          end
        end)
      end, { desc = "Initialize opencode project" })

      vim.keymap.set("n", "<leader>ox", function()
        local has_opencode = ctx.has_opencode_dir()
        if has_opencode then
          require("opencode").ask("@project Read .opencode/AGENTS.md and apply to this session")
        else
          vim.notify("No .opencode/ directory found. Run :OpencodeInitProject to create one.", vim.log.levels.WARN)
        end
      end, { desc = "Load project agents" })

      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
  },
}
