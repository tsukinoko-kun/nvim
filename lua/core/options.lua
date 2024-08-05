local opt = vim.opt

opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
opt.lazyredraw = true -- Faster scrolling
--opt.synmaxcol = 240 -- Max column for syntax highlight
opt.updatetime = 700 -- ms to wait for trigger an event

vim.o.completeopt = "menuone,noinsert,noselect"
vim.wo.signcolumn = "yes"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.cmd("set nofoldenable")
vim.cmd("set showcmd")

-- disable mouse
-- opt.mouse = ""

-- timeout
opt.timeoutlen = 500
opt.timeout = true

-- line numbers
opt.relativenumber = true
opt.number = true

-- indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- line wrapping
opt.wrap = true

-- search
opt.ignorecase = true
opt.smartcase = true
vim.cmd("set rtp+=/opt/homebrew/opt/fzf")

-- cursor line
opt.cursorline = true
opt.cursorcolumn = true
local lineHi = vim.api.nvim_get_hl(0, { name = "CursorLine" })
local c = require("catppuccin.palettes.mocha")
vim.api.nvim_set_hl(0, "CursorLine", { fg = lineHi.fg, bg = c.mantle, sp = lineHi.sp, nocombine = lineHi.nocombine })
vim.api.nvim_set_hl(0, "CursorColumn", { fg = lineHi.fg, bg = c.mantle, sp = lineHi.sp, nocombine = lineHi.nocombine })

-- scrolloff
opt.scrolloff = 8

-- appearance
opt.background = "dark"
opt.signcolumn = "yes"
opt.showmode = false
opt.termguicolors = true

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- keywords
opt.iskeyword:append("_")
