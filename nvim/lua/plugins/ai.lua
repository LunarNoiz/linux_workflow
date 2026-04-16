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
          enabled = false,
          filetypes = nil,
        },
      }

      vim.o.autoread = true

      vim.keymap.set({ "n", "x", "t" }, "<C-a>", function()
        require("opencode").toggle()
      end, { desc = "Ask opencode…" })

      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask()
      end, { desc = "Ask Agent" })

      -- Custom Async Hover <S-k>
      vim.keymap.set({ "n", "x" }, "<S-k>", function()
        local function get_hover_text()
          local mode = vim.api.nvim_get_mode().mode
          if mode == "v" or mode == "V" or mode == "\22" then
            -- visual mode
            local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
            local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
            local lines = vim.api.nvim_buf_get_lines(0, csrow - 1, cerow, false)
            if #lines == 0 then return "" end
            if #lines == 1 then
              lines[1] = string.sub(lines[1], cscol, cecol)
            else
              lines[1] = string.sub(lines[1], cscol)
              lines[#lines] = string.sub(lines[#lines], 1, cecol)
            end
            return table.concat(lines, "\n")
          else
            -- normal mode: word under cursor
            return vim.fn.expand("<cword>")
          end
        end

        local text = get_hover_text()
        if not text or text == "" then return end

        if _G.opencode_hover_job and not _G.opencode_hover_job:is_closing() then
          _G.opencode_hover_job:kill(9)
          _G.opencode_hover_job = nil
        end

        local win_id = vim.api.nvim_get_current_win()
        local start_pos = vim.api.nvim_win_get_cursor(win_id)
        local bufnr = vim.api.nvim_get_current_buf()

        vim.notify("Asking opencode...", vim.log.levels.INFO)

        _G.opencode_hover_job = vim.system({
          "opencode",
          "run",
          "--agent", "ask",
          "Explain this code: " .. text
        }, { text = true }, function(out)
          vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win_id) or vim.api.nvim_get_current_win() ~= win_id then return end
            if vim.api.nvim_get_current_buf() ~= bufnr then return end
            
            local current_pos = vim.api.nvim_win_get_cursor(win_id)
            if current_pos[1] ~= start_pos[1] or current_pos[2] ~= start_pos[2] then
              -- Cursor moved, do not show popup
              return
            end

            if out.code ~= 0 then
              vim.notify("opencode error: " .. (out.stderr or out.stdout or ""), vim.log.levels.ERROR)
              return
            end

            local output = out.stdout or ""
            -- Remove any empty lines at start/end
            output = output:gsub("^%s*\n", ""):gsub("\n%s*$", "")
            local lines = vim.split(output, "\n")
            vim.lsp.util.open_floating_preview(lines, "markdown", {
              border = "rounded",
              focus_id = "opencode_hover"
            })
          end)
        end)
      end, { desc = "Async opencode Hover" })

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
