local api = vim.api

-- Language Specific Indents
local indent_group = api.nvim_create_augroup("LanguageSpecificIndents", { clear = true })

api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = { "python", "rust", "java" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = "asm",
  callback = function()
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 8
    vim.bo.tabstop = 8
    vim.bo.expandtab = false
  end,
})

-- Auto-close NvimTree if it's the last window
local function is_sidebar_buffer(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local ft = vim.bo[bufnr].filetype
  return name:match(".*NvimTree_%d*$") or ft == "undotree" or ft == "diff"
end

local function tab_win_closed(winnr)
  local tree_api = require("nvim-tree.api")
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)

  if vim.api.nvim_buf_get_name(bufnr):match(".*NvimTree_%d*$") then
    if not vim.tbl_isempty(tab_bufs) then tree_api.tree.close() end
    return
  end

  local only_sidebars_left = #tab_bufs > 0
  for _, b in ipairs(tab_bufs) do
    if not is_sidebar_buffer(b) then
      only_sidebars_left = false
      break
    end
  end

  if only_sidebars_left then
    vim.schedule(function() vim.cmd("qa") end)
  end
end

api.nvim_create_autocmd("WinClosed", {
  callback = function()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    if winnr and api.nvim_win_is_valid(winnr) then
      tab_win_closed(winnr)
    end
  end,
  nested = true,
})

-- Enforce winfixwidth for sidebars so standard splits don't resize them
api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = api.nvim_create_augroup("FixSidebarWidths", { clear = true }),
  callback = function()
    local ft = vim.bo.filetype
    if ft == "NvimTree" or ft == "undotree" or ft == "diff" then
      vim.wo.winfixwidth = true
    end
  end,
})

-- Auto-open NvimTree and Undotree on startup
api.nvim_create_autocmd("VimEnter", {
  group = api.nvim_create_augroup("AutoOpenSidebars", { clear = true }),
  callback = function()
    -- Give Lazy a moment to load everything if needed
    vim.schedule(function()
      require("nvim-tree.api").tree.open()
      vim.cmd("UndotreeShow")
      -- Return focus to the main center window
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft ~= "NvimTree" and ft ~= "undotree" and ft ~= "diff" then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end)
  end,
})


