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
	print("LSP " .. client.name .. " attached")

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
	km.set("n", "<leader>lf", vim.lsp.buf.format, opts) -- format file
	km.set("n", "<leader>lF", vim.lsp.buf.range_formatting, opts) -- format selection
	km.set("n", "K", vim.lsp.buf.hover, opts) -- show document symbols

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		km.set("n", "<leader>lrf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		km.set("n", "<leader>loi", ":TypescriptOrganizeImports<CR>") -- organize imports
		km.set("n", "<leader>lru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
	end

	-- c / c++ specific keymaps (e.g. toggle header/source)
	if client.name == "clangd" then
		km.set("n", "gh", ":ClangdSwitchSourceHeader<CR>") -- toggle header/source
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
	settings = {
		-- custom settings for lua
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
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			root_dir = lspconfig.util.root_pattern("Cargo.toml"),
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

local rusttools = require("rust-tools")

local opts = {
	tools = { -- rust-tools options
		-- Automatically set inlay hints (type hints)
		autoSetHints = true,

		-- Whether to show hover actions inside the hover window
		-- This overrides the default hover handler
		-- hover_with_actions = true,

		runnables = {
			-- whether to use telescope for selection menu or not
			use_telescope = true,

			-- rest of the opts are forwarded to telescope
		},

		debuggables = {
			-- whether to use telescope for selection menu or not
			use_telescope = true,

			-- rest of the opts are forwarded to telescope
		},

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {

			-- Only show inlay hints for the current line
			only_current_line = false,

			-- Event which triggers a refersh of the inlay hints.
			-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
			-- not that this may cause  higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			only_current_line_autocmd = "CursorHold",

			-- wheter to show parameter hints with the inlay hints or not
			show_parameter_hints = true,

			-- prefix for parameter hints
			parameter_hints_prefix = "<- ",

			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = "=> ",

			-- whether to align to the length of the longest line in the file
			max_len_align = false,

			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,

			-- whether to align to the extreme right or not
			right_align = false,

			-- padding from the right if right_align is true
			right_align_padding = 7,

			-- The color of the hints
			highlight = "Comment",
		},

		-- settings for showing the crate graph based on graphviz and the dot
		-- command
		crate_graph = {
			-- Backend used for displaying the graph
			-- see: https://graphviz.org/docs/outputs/
			-- default: x11
			backend = "x11",
			-- where to store the output, nil for no output stored (relative
			-- path from pwd)
			-- default: nil
			output = nil,
			-- true for all crates.io and external crates, false only the local
			-- crates
			-- default: true
			full = true,
		},
	},
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
	dap = {
		adapter = {
			type = "executable",
			command = "lldb-vscode",
			name = "rt_lldb",
		},
	},
}

rusttools.setup(opts)
rusttools.inlay_hints.enable()

-- configure astro server
lspconfig["astro"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		astro = {
			enable = true,
			root_dir = lspconfig.util.root_pattern(
				"astro.config.mjs",
				"astro.config.js",
				"astro.config.cjs",
				"package.json",
				"node_modules",
				".git"
			) or lspconfig.util.path.dirname,
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
			root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
				or lspconfig.util.path.dirname,
			filetypes = { "c", "h", "hpp", "cpp", "cpi", "objc", "objcpp" },
			single_file_support = true,
		},
	},
})

require("clangd_extensions").setup({
	server = { capabilities = capabilities, on_attach = on_attach },
	extensions = {
		-- defaults:
		-- Automatically set inlay hints (type hints)
		autoSetHints = true,
		-- These apply to the default ClangdSetInlayHints command
		inlay_hints = {
			-- Only show inlay hints for the current line
			only_current_line = false,
			-- Event which triggers a refersh of the inlay hints.
			-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
			-- not that this may cause  higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			only_current_line_autocmd = "CursorHold",
			-- whether to show parameter hints with the inlay hints or not
			show_parameter_hints = true,
			-- prefix for parameter hints
			parameter_hints_prefix = "<- ",
			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = "=> ",
			-- whether to align to the length of the longest line in the file
			max_len_align = false,
			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,
			-- whether to align to the extreme right or not
			right_align = false,
			-- padding from the right if right_align is true
			right_align_padding = 7,
			-- The color of the hints
			highlight = "Comment",
			-- The highlight group priority for extmark
			priority = 100,
		},
		ast = {
			role_icons = {
				type = "",
				declaration = "",
				expression = "",
				specifier = "",
				statement = "",
				["template argument"] = "",
			},

			kind_icons = {
				Compound = "",
				Recovery = "",
				TranslationUnit = "",
				PackExpansion = "",
				TemplateTypeParm = "",
				TemplateTemplateParm = "",
				TemplateParamObject = "",
			},

			highlights = {
				detail = "Comment",
			},
		},
		memory_usage = {
			border = "none",
		},
		symbol_info = {
			border = "none",
		},
	},
})
