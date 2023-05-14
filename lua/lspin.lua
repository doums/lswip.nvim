-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- local init_cfg = require('lsp_wip.config').init
local lspin = require('lspin.lspin')
local cfg = require('lspin.config')

local M = {}

function M.setup(config)
  config = cfg.init(config or {})
  lspin.init(config)
end

M.group = lspin.group
M.get = lspin.get

return M
