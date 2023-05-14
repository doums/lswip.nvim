-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

local spinner_mod = require('lspin.spinner').spinner
local group_id = vim.api.nvim_create_augroup('lspin', {})
local spinner

function M.init(config)
  spinner = spinner_mod:new(config.interval, config.frames, group_id)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspProgressUpdate',
    group = group_id,
    desc = 'LSP progress notification',
    callback = function()
      local clients = vim.lsp.get_active_clients()
      local is_wip = vim.tbl_contains(clients, function(client)
        return vim.tbl_contains(client.messages.progress, function(msg)
          return not msg.done
        end, { predicate = true })
      end, { predicate = true })

      if is_wip and not spinner:is_spinning() then
        spinner:start()
      end
      if not is_wip and spinner:is_spinning() then
        spinner:stop()
      end
    end,
  })

  if config.redrawstatus then
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LspinUpdate',
      group = group_id,
      desc = 'Lsp spinner update',
      callback = function()
        vim.cmd('redrawstatus' .. (config.redrawstatus == '!' and '!' or ''))
      end,
    })
  end

  vim.api.nvim_create_autocmd('VimLeavePre', {
    pattern = '*',
    group = group_id,
    callback = function()
      spinner:close()
    end,
  })
end

function M.get()
  return spinner:get()
end

M.group = group_id

return M
