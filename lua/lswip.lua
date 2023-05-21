-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

-- local init_cfg = require('lsp_wip.config').init
local lswip = require('lswip.lswip')
local cfg = require('lswip.config')

local M = {}

function M.setup(config)
  config = cfg.init(config or {})
  lswip.init(config)
end

M.group = lswip.group
M.get = lswip.get

return M
