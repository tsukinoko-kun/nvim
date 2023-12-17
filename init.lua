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

-- Autoformat on save
AutoFormatActive = false

local format = function()
    vim.cmd("silent! write")
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    })
    vim.cmd("silent! write")
end

function FormatAndSave()
    if AutoFormatActive then
        pcall(format)
    end
end

vim.cmd([[
    augroup InsertModeLeave
        autocmd!
        autocmd InsertLeave * lua FormatAndSave()
    augroup END
]])

local utils = require("utils")
utils.map("n", "<leader>taf", function()
    AutoFormatActive = not AutoFormatActive
    if AutoFormatActive then
        print("Autoformat: ON")
    else
        print("Autoformat: OFF")
    end
end)

-- clear jump list autocmd VimEnter
vim.cmd([[
    autocmd VimEnter * :clearjumps
]])
