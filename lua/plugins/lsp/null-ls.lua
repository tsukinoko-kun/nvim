local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		formatting.prettier.with({
			-- indent size 4 spaces, trailing comma
			extra_args = { "--tab-width", "4", "--trailing-comma", "all" },
		}),
		formatting.stylua, -- lua formatter
		formatting.clang_format, -- c/c++ formatter
		formatting.rustfmt, -- rust formatter
		formatting.eslint_d.with({ -- js/ts linter
			condition = function(utils)
				-- only if eslint config file is present
				return utils.root_has_file(".eslintrc.js")
					or utils.root_has_file(".eslintrc.cjs")
					or utils.root_has_file(".eslintrc.yaml")
					or utils.root_has_file(".eslintrc.yml")
					or utils.root_has_file(".eslintrc.json")
			end,
		}),
		diagnostics.eslint_d.with({ -- js/ts linter
			condition = function(utils)
				-- only if eslint config file is present
				return utils.root_has_file(".eslintrc.js")
					or utils.root_has_file(".eslintrc.cjs")
					or utils.root_has_file(".eslintrc.yaml")
					or utils.root_has_file(".eslintrc.yml")
					or utils.root_has_file(".eslintrc.json")
			end,
		}),
		diagnostics.jsonlint, -- json
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						async = true,
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
