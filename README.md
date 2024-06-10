# :window: winresize.nvim

A neovim plugin provide apis for resizing window as we expected.

## :clipboard: Requirements

* Neovim >= 0.10.0

## :notebook: Introduction

When we editing files with multiple windows, you may notice a window is small
for editing the file and will try to resize it.

The neovim provides keymaps such that `CTRL-W_+`, `CTRL-W_-`, `CTRL-W_>` and `CTRL-W_<`.
But these are a little bit hard to press, so you will define keymaps like below.

```lua
vim.keymap.set("n", "rh", "<C-w><")
vim.keymap.set("n", "rj", "<C-w>+")
vim.keymap.set("n", "rk", "<C-w>-")
vim.keymap.set("n", "rl", "<C-w>>")
```

This keymaps works well when we are here of such layout, as `rh` and `rl` moves
right edge of the window, and `rj` and `rk` moves bottom edge of the window.

```
+-------------+-------------+
|             |             |
|    here     |             |
|             |             |
+-------------+-------------+
|                           |
|                           |
|                           |
+---------------------------+
```

But unfortunately, the keymaps doesn't works when we are here of the layout, as the
movement of `rh` and `rl` inverted compare to as we expected.

```
+-------------+-------------+
|             |             |
|             |    here     |
|             |             |
+-------------+-------------+
|                           |
|                           |
|                           |
+---------------------------+
```

So, this plugin provide `resize` function for such purpose. You can use it as follow.

```lua
local resize = require("winresize").resize
vim.keymap.set("n", "rh", resize(0, 2, 2, "left"))
vim.keymap.set("n", "rj", resize(0, 2, 2, "down"))
vim.keymap.set("n", "rk", resize(0, 2, 2, "up"))
vim.keymap.set("n", "rl", resize(0, 2, 2, "right"))
```

With it, you can resize window intutively.

## :inbox_tray: Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    "pogyomo/winresize.nvim",
}
```

## :bulb: Examples

Use this with [submode.nvim](https://github.com/pogyomo/submode.nvim)

```lua
local submode = require("submode")
submode.create("WinResize", {
    mode = "n",
    enter = "<Leader>r",
    leave = { "q", "<ESC>" },
}, {
    lhs = "h",
    rhs = function() resize(0, 2, 2, "left") end,
}, {
    lhs = "j",
    rhs = function() resize(0, 2, 2, "down") end,
}, {
    lhs = "k",
    rhs = function() resize(0, 2, 2, "up") end,
}, {
    lhs = "l",
    rhs = function() resize(0, 2, 2, "right") end,
})
```

## :desktop_computer: APIS

- `resize(win, diff_width, diff_height, key)`
    - `win: integer` Window handle for resize. 0 for current window.
    - `diff_width: integer` How much to move when resize window width. Must be positive.
    - `diff_height: integer` How much to move when resize window height. Must be positive.
    - `key: "left" | "right" | "up" | "down"` Type of direction key to be used to resize.
