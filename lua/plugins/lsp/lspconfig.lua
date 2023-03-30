-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local km = vim.keymap

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
	km.set("n", "gD", vim.lsp.buf.declaration, opts) -- got to declaration
	km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- see definition and make edits in window
	km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- go to implementation
	km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- go to implementation
	km.set("n", "<leader>la", vim.lsp.buf.code_action, opts) -- see available code actions
	km.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
	km.set("n", "<leader>lr", ":IncRename ", opts) -- smart rename
	km.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
	km.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line
	km.set("n", "<leader>lgD", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
	km.set("n", "<leader>lgd", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
	km.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		km.set("n", "<leader>lrf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		km.set("n", "<leader>loi", ":TypescriptOrganizeImports<CR>") -- organize imports
		km.set("n", "<leader>lru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "astro" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- configure rust server
lspconfig["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

-- configure astro server
lspconfig["astro"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		astro = {
			enable = true,
		},
	},
})

-- configure c/c++ server
lspconfig["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		clangd = {
			compileCommandsDir = "build",
		},
	},
})
