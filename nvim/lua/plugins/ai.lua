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
    "ravitemer/codecompanion-history.nvim",
    dependencies = { "olimorris/codecompanion.nvim", "folke/snacks.nvim" },
  },
  {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    keys = {
      { "<C-a>", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<C-a>", "<Esc><cmd>CodeCompanionChat Toggle<cr>", mode = "i", desc = "Toggle AI Chat" },
      { "<leader>ac", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    },
    opts = {
      system_prompt = function(ctx)
        return table.concat({
          ctx.default_system_prompt,
          "",
          "You are an AI programming and security analysis assistant.",
          "Follow the user's requirements exactly.",
          "When the user asks for code, prefer returning complete runnable scripts.",
          "Do not invent facts. If uncertain, say so.",
          "Do not mix code and explanation unless the user asks for both.",
        }, "\n")
      end,
      adapters = {
        http = {
          opts = {
            show_model_choices = false,
          },
          openclaw = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "openclaw",
              formatted_name = "OpenClaw",
              env = {
                url = "http://127.0.0.1:18789",
                api_key = "OPENCLAW_GATEWAY_TOKEN",
              },
              schema = {
                model = {
                  default = "openclaw:main",
                },
                temperature = {
                  default = 0,
                },
                max_tokens = {
                  default = 8192,
                },
              },
            })
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = false,
            make_vars = false,
            make_slash_commands = true,
          },
        },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            continue_last_chat = true,
            delete_on_clearing_chat = true,
            expiration_days = 0,
            picker = "snacks",
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "y", i = "<M-y>" },
            },
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_history",
          },
        },
      },
      interactions = {
        chat = {
          adapter = "openclaw",
          keymaps = {
            send = { modes = { n = "<CR>", i = "<C-CR>" } },
            close = { modes = { n = "q" } },
          },
        },
        inline = { adapter = "openclaw" },
        cmd = { adapter = "openclaw" },
      },
      display = {
        chat = {
          show_settings = false,
          window = {
            layout = "float",
            width = 0.8,
            height = 0.8,
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept_word = "<M-l>", 
            accept_line = "<M-;>", 
            accept = "<M-'>",      
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = true }, 
      })
    end,
  },
}
