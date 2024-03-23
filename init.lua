-- set language
if not pcall(function()
    vim.cmd("lang en_US.UTF-8")
end) then
    print("Failed to set locale")
end

vim.opt.termguicolors = true
vim.g.mapleader = " "

require("plugins-setup")
require("core.options")
require("core.keymaps")
require("core.colorscheme")
require("core.format")

-- clear jump list autocmd VimEnter
vim.cmd("autocmd VimEnter * :clearjumps")

vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")
