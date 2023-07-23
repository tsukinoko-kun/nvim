local opt = vim.opt

vim.o.completeopt = "menuone,noinsert,noselect"
vim.wo.signcolumn = "yes"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.cmd("set nofoldenable")
vim.cmd("set showcmd")

-- disable mouse
opt.mouse = ""

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
opt.colorcolumn = "80"

-- search
opt.ignorecase = true
opt.smartcase = true
vim.cmd("set rtp+=/opt/homebrew/opt/fzf")

-- cursor line
opt.cursorline = true

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
