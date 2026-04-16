local M = {}

function M.get_git_root()
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fn.finddir('.git', cwd .. ';')
  if git_dir ~= '' then
    return vim.fn.fnamemodify(git_dir, ':h:h')
  end
  return cwd
end

function M.get_project_name()
  local root = M.get_git_root()
  return vim.fn.fnamemodify(root, ':t')
end

function M.get_filetype_context()
  local ft = vim.bo.filetype
  if ft == '' or ft == 'qf' then
    return ''
  end
  
  local contexts = {
    lua = 'Lua project',
    python = 'Python project',
    javascript = 'JavaScript project',
    typescript = 'TypeScript project',
    rust = 'Rust project',
    go = 'Go project',
    c = 'C project',
    cpp = 'C++ project',
    vim = 'Vim script',
    markdown = 'Markdown documentation',
  }
  
  return contexts[ft] or (ft .. ' project')
end

function M.detect_project_language()
  local root = M.get_git_root()
  
  local markers = {
    { file = 'Cargo.toml', lang = 'Rust' },
    { file = 'package.json', lang = 'JavaScript/TypeScript' },
    { file = 'go.mod', lang = 'Go' },
    { file = 'requirements.txt', lang = 'Python' },
    { file = 'init.lua', lang = 'Lua' },
    { file = 'Makefile', lang = 'C/Make' },
    { file = 'CMakeLists.txt', lang = 'C++/CMake' },
  }
  
  for _, marker in ipairs(markers) do
    if vim.fn.findfile(marker.file, root) ~= '' then
      return marker.lang
    end
  end
  
  return 'Unknown'
end

function M.get_project_context()
  local root = M.get_git_root()
  local name = M.get_project_name()
  local lang = M.detect_project_language()
  local ft_context = M.get_filetype_context()
  
  local has_opencode = vim.fn.isdirectory(root .. '/.opencode') == 1
  
  local ctx = string.format(
    '[Project: %s]\n[Language: %s]\n[Root: %s]',
    name, lang, root
  )
  
  if ft_context ~= '' then
    ctx = ctx .. '\n[' .. ft_context .. ']'
  end
  
  if has_opencode then
    ctx = ctx .. '\n[Has .opencode/ directory]'
  end
  
  return ctx
end

function M.has_opencode_dir()
  local root = M.get_git_root()
  return vim.fn.isdirectory(root .. '/.opencode') == 1
end

function M.get_opencode_dir()
  local root = M.get_git_root()
  local opencode_path = root .. '/.opencode'
  
  if vim.fn.isdirectory(opencode_path) == 1 then
    return opencode_path
  end
  
  return nil
end

return M
