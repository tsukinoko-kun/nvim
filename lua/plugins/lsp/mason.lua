local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"rust_analyzer", -- rust
		"astro", -- astro
		"clangd", -- c, c++, objc
		"tsserver", -- ts/js
		"html", -- html
		"cssls", -- css, scss, less
		"lua_ls", -- lua
		"emmet_ls", -- html, css, js, jsx, ts, tsx
		"marksman", -- markdown
		"yamlls", -- yaml
		"lemminx", -- xml
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"rustfmt", -- rust formatter
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
		"markdownlint", -- markdown linter
		"sumneko_lua", -- lua linter
		"clang-format", -- c, c++, objc formatter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})
