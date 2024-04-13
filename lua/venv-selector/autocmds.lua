local activate_parent_venv = require('venv-selector.venv').activate_parent_venv

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {}

local group = augroup("VenvSelectorGroup", {})

-- This will automatically update the venv when we navigate buffers
function M.register_on_buf_enter_autocmd()
  autocmd("BufEnter", {
    pattern = "*.py",
    group = group,
    callback = activate_parent_venv
  })
end

-- PersistedLoadPost is fired by persisted.nvim on session load
-- Activate the venv on LspAttach after session load
function M.register_on_persisted_load_post_autocmd()
  autocmd("User", {
    pattern = "PersistedLoadPost",
    group = group,
    callback = function()
      autocmd("LspAttach", {
          pattern = "*.py",
          group = augroup("VenvSelectorPersistedLoadGroup", { clear = true }),
          callback = activate_parent_venv,
          once = true
      })
    end
  })
end

return M
