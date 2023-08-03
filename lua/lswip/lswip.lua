-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

local spinner_mod = require('lswip.spinner').spinner
local group_id = vim.api.nvim_create_augroup('lswip', {})
local spinner

function M.init(config)
  spinner = spinner_mod:new(config.interval, config.frames, group_id)

  vim.api.nvim_create_autocmd('LspProgress', {
    group = group_id,
    desc = 'LSP progress notification',
    callback = function()
      local clients = vim.iter(vim.lsp.get_clients())
      local is_wip = clients:any(function(client)
        local msg = vim.iter(client.progress):last()
        client.progress:clear()
        if not msg then
          return false
        end
        local kind = vim.tbl_get(msg, 'value', 'kind')
        return kind == 'report' or kind == 'begin'
      end)

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
      pattern = 'LswipUpdate',
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
