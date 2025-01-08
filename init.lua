-- set language
pcall(function()
    vim.cmd("lang en_US.UTF-8")
end)

vim.opt.termguicolors = true
vim.g.mapleader = " "

require("plugins-setup")
require("core.keymaps")
require("core.format")
require("core.options")

-- clear jump list autocmd VimEnter
vim.cmd("autocmd VimEnter * :clearjumps")

vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")

-- vim.cmd.colorscheme(require("utils").get_appearance_mode() == "dark" and "catppuccin-mocha" or "catppuccin-latte")
vim.cmd.colorscheme("catppuccin-mocha")

local lineHi = vim.api.nvim_get_hl(0, { name = "CursorLine" })
-- local c = require(require("utils").get_appearance_mode() == "dark" and "catppuccin.palettes.mocha" or "catppuccin.palettes.latte")
local c = require("catppuccin.palettes.mocha")
vim.api.nvim_set_hl(0, "CursorLine", { fg = lineHi.fg, bg = c.mantle, sp = lineHi.sp, nocombine = lineHi.nocombine })
vim.api.nvim_set_hl(0, "CursorColumn", { fg = lineHi.fg, bg = c.mantle, sp = lineHi.sp, nocombine = lineHi.nocombine })
