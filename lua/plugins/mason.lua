return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local mason = require("mason")
        mason.setup()
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "rust_analyzer", -- rust
                "astro",         -- astro
                "clangd",        -- c, c++, objc
                "tsserver",      -- ts/js
                "gopls",         -- go
                "html",          -- html
                "cssls",         -- css, scss, less
                "lua_ls",        -- lua
                "jsonls",        -- json
                "marksman",      -- markdown
                "yamlls",        -- yaml
                "lemminx",       -- xml
                "jdtls",         -- java
                "pyright",       -- python
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })
    end,
}
