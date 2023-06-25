return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jayp0521/mason-null-ls.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local mason = require "mason"
        mason.setup()
        local mason_lspconfig = require "mason-lspconfig"
        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "rust_analyzer", -- rust
                "astro", -- astro
                "clangd", -- c, c++, objc
                "tsserver", -- ts/js
                "gopls", -- go
                "html", -- html
                "cssls", -- css, scss, less
                "lua_ls", -- lua
                "jsonls", -- json
                "marksman", -- markdown
                "yamlls", -- yaml
                "lemminx", -- xml
                "jdtls", -- java
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })
        local mason_null_ls = require "mason-null-ls"
        mason_null_ls.setup({
            -- list of formatters & linters for mason to install
            ensure_installed = {
                "rustfmt", -- rust formatter
                "prettier", -- ts/js formatter
                "stylua", -- lua formatter
                "eslint_d", -- ts/js linter
                "jsonlint", -- json linter
                "markdownlint", -- markdown linter
                "lua_ls", -- lua linter
                "clang-format", -- c, c++, objc formatter
                "google-java-format", -- java formatter
            },
            -- auto-install configured formatters & linters (with null-ls)
            automatic_installation = true,
        })
    end
}
