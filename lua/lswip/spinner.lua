-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = { spinner = {} }

function M.spinner:new(interval, frames, autocmd_group)
  local instance = {
    timer = vim.loop.new_timer(),
    interval = interval,
    frames = frames,
    frame = 1,
    autocmd_group = autocmd_group,
  }
  self.__index = self
  return setmetatable(instance, self)
end

function M.spinner:start(cb)
  self.frame = 1
  self.timer:start(
    0,
    self.interval,
    vim.schedule_wrap(function()
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'LswipUpdate',
        group = self.autocmd_group,
        data = {
          spin = true,
          frame = self.frames[self.frame],
        },
      })
      if cb then
        cb(self.frames[self.frame])
      end
      self.frame = self.frame < #self.frames and self.frame + 1 or 1
    end)
  )
end

function M.spinner:stop()
  self.timer:stop()
  self.frame = 1
  vim.api.nvim_exec_autocmds('User', {
    pattern = 'LswipUpdate',
    group = self.autocmd_group,
    data = {
      spin = false,
    },
  })
end

function M.spinner:close(notify)
  self.timer:close()
  if not notify then
    return
  end
  vim.api.nvim_exec_autocmds('User', {
    pattern = 'LswipUpdate',
    group = self.autocmd_group,
    data = {
      spin = false,
    },
  })
end

function M.spinner:is_spinning()
  return self.timer:is_active()
end

function M.spinner:get()
  if self.timer:is_active() then
    return self.frames[self.frame]
  end
end

return M
