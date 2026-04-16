local M = {}

local TEMPLATE_AGENTS = [[
---
description: Custom project agent
mode: subagent
---

Add your custom agent instructions here.
]]

local TEMPLATE_OPENCODE_JSON = [[
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["AGENTS.md"]
}
]]

local TEMPLATE_AGENTS_MD = [[
# Project: %s

## Overview
Brief description of this project.

## Tech Stack
- Language/Framework 1
- Language/Framework 2

## Structure
Describe the project directory structure.

## Conventions
- Coding style guidelines
- Naming conventions
- Git workflow

## Commands
Common commands for development:
- `make dev` - Start development server
- `make test` - Run tests

## Notes
Additional project-specific notes for the AI agent.
]]

function M.create_opencode_dir()
  local root = vim.fn.getcwd()
  local opencode_path = root .. '/.opencode'
  
  if vim.fn.isdirectory(opencode_path) == 1 then
    vim.notify('Opencode directory already exists: ' .. opencode_path, vim.log.levels.WARN)
    return false
  end
  
  vim.fn.mkdir(opencode_path, 'p')
  vim.fn.mkdir(opencode_path .. '/agents', 'p')
  vim.fn.mkdir(opencode_path .. '/commands', 'p')
  vim.fn.mkdir(opencode_path .. '/prompts', 'p')
  
  vim.fn.writefile({ TEMPLATE_OPENCODE_JSON }, opencode_path .. '/opencode.json')
  
  local project_name = vim.fn.fnamemodify(root, ':t')
  local agents_md_content = string.format(TEMPLATE_AGENTS_MD, project_name)
  vim.fn.writefile(vim.split(agents_md_content, '\n'), opencode_path .. '/AGENTS.md')
  
  vim.fn.writefile(vim.split(TEMPLATE_AGENTS, '\n'), opencode_path .. '/agents/custom.md')
  
  vim.notify('Created .opencode/ directory in: ' .. root, vim.log.levels.INFO)
  return true
end

function M.init_project(template)
  local root = require('oc_harness.context').get_git_root()
  local original_cwd = vim.fn.getcwd()
  
  if template == nil or template == "" then
    template = "generic"
  end

  vim.cmd('cd ' .. root)
  
  if vim.fn.isdirectory(root .. '/.claude') == 1 or vim.fn.isdirectory(root .. '/.opencode') == 1 then
    vim.notify('Harness directory already exists. Aborting to prevent data loss.', vim.log.levels.WARN)
    vim.cmd('cd ' .. original_cwd)
    return false
  end

  local cmd = string.format("oc-init %s", template)
  local result = vim.fn.system(cmd)
  
  if vim.v.shell_error ~= 0 then
    vim.notify('Error initializing project: ' .. result, vim.log.levels.ERROR)
    vim.cmd('cd ' .. original_cwd)
    return false
  end

  vim.notify('Project initialized with template: ' .. template, vim.log.levels.INFO)
  vim.cmd('cd ' .. original_cwd)
  return true
end

vim.api.nvim_create_user_command('OpencodeInitProject', function(opts)
  M.init_project(opts.args)
end, {
  nargs = "?",
  desc = 'Initialize .opencode/ directory for the current project',
  complete = function()
    return {"generic", "python", "web", "c_cpp", "go"}
  end
})

return M
