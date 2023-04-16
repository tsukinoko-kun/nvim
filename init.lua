-- set language
if not pcall(function()
	vim.cmd("lang en_US")
end) then
	print("Failed to set language to en_US")
end

require("plugins-setup")

-- core
require("core.options")
require("core.keymaps")
require("core.colorscheme")

-- plugins
require("plugins.comment")
require("plugins.nvim-tree")
require("plugins.lualine")
require("plugins.telescope")
require("plugins.nvim-cmp")
require("plugins.lsp.mason")
require("plugins.lsp.lspconfig")
require("plugins.lsp.null-ls")
require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.nvim-colorizer")
require("plugins.gitsigns")
