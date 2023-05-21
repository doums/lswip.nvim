## lswip.nvim

Show a spinner whenever there is LSP job in progress

### Install

```lua
paq('doums/lswip.nvim')
```

### Config

```lua
local lswip = require('lswip')

lswip.setup({
  -- Spinner frame interval (ms)
  interval = 80,
  -- Spinner frames
  frames = { '▪', '■', '□', '▫' },
  -- Redraw statuslines on spinner updates (new frame)
  -- see :h redrawstatus
  -- set to '!' for :redrawstatus! equivalent
  redrawstatus = false,
})
```

### Usage

#### `lswip` module

The following API is exposed

- `get`: `fn ()` -> `string` | `nil`

Returns the current spinner frame or `nil` if there is no work in
progress

- `group`: `string`

Autocmd group ID used internally by `lswip`

#### autocmd `LswipUpdate`

**User** autocmd to get notified on spinner updates

The following `data` table is passed to the callback function arguments

```lua
{
  spin = true -- either the spinner spins or not
  frame = '▪' -- current spinner frame (if spinning)
}
```

### License

Mozilla Public License 2.0
