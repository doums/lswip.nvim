-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

local group_id = vim.api.nvim_create_augroup('lsp_wip', {})
local wip = false

function M.init(config)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspProgressUpdate',
    group = group_id,
    desc = 'LSP progress notification',
    callback = function()
      local clients = vim.lsp.get_active_clients()
      for _, client in pairs(clients) do
        vim.print(client.messages.progress)
      end
      -- for _, client in pairs(vim.lsp.buf_get_clients()) do -- loop over each client to check notifications
      --   if not client_notifs[bufnr] then -- create buffer specific notification table if not exists
      --     client_notifs[bufnr] = {}
      --   end
      --   if not client_notifs[bufnr][client.id] then -- create buffers client  specific  notification table if not exists
      --     client_notifs[bufnr][client.id] = {}
      --   end
      --   local notif_data = client_notifs[bufnr][client.id] -- set notif_data variable
      --   local progress = nil
      --   for _, progress_msg in pairs(client.messages.progress) do
      --     progress = true -- expose if a progress exists
      --     if not progress_msg.done then
      --       progress = progress_msg -- get clients first not done progress messages
      --       break
      --     end
      --   end
      --   if
      --     type(progress) == 'table'
      --     and progress.percentage
      --     and progress.percentage ~= 0
      --   then -- if there is a progress message
      --     local notify_opts = {} -- define notification options
      --     local new_msg = notif_data.notification == nil -- if it's a new message set different options
      --     if new_msg then -- for new messages set a title, initialize icone and disable timeout
      --       notify_opts = {
      --         title = client.name
      --           .. (#progress.title > 0 and ': ' .. progress.title or ''),
      --         icon = spinner_frames[1],
      --         timeout = false,
      --       }
      --     else -- for existing messages just update the existing notification
      --       notify_opts = { replace = notif_data.notification }
      --     end
      --     notif_data.notification =
      --       vim.notify( -- notify with percentage and message
      --         (progress.percentage and progress.percentage .. '%\t' or '')
      --           .. (progress.message or ''),
      --         'info',
      --         notify_opts
      --       )
      --     if new_msg then -- if it's a new message, start the update spinner background job
      --       update_spinner(notif_data)
      --     end
      --   elseif progress and not vim.tbl_isempty(notif_data) then -- if there is finished progress and a notification, complete it
      --     notif_data.notification = vim.notify(
      --       'Complete',
      --       'info',
      --       { icon = '', replace = notif_data.notification, timeout = 3000 }
      --     )
      --     notif_data = {} -- clear notification data
      --   end
      -- end
    end,
  })
end

return M
