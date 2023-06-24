-- set language
if not pcall(function()
    vim.cmd("lang en_US.UTF-8")
end) then
    print("Failed to set locale")
end

require("plugins-setup")

-- core
require("core.options")
require("core.keymaps")
require("core.colorscheme")

-- plugins
require("plugins.netrw")
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
require("plugins.catppuccin")

-- dap
require("plugins.dap.dap")
require("plugins.dap.mason")
require("plugins.dap.nvim-dap-virtual-text")
require("plugins.dap.dapui")
