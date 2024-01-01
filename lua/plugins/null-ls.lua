return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.eslint,
                    null_ls.builtins.formatting.gofmt,
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.goimports_reviser,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.google_java_format,
                    null_ls.builtins.formatting.bibclean,
                    null_ls.builtins.formatting.latexindent,
                    null_ls.builtins.formatting.stylelint,
                    null_ls.builtins.formatting.templ,

                    null_ls.builtins.completion.spell,

                    null_ls.builtins.code_actions.ltrs, -- cargo install languagetool-rust --features full
                    null_ls.builtins.code_actions.impl,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.gomodifytags,

                    null_ls.builtins.diagnostics.actionlint,
                    null_ls.builtins.diagnostics.chktex,
                    null_ls.builtins.diagnostics.editorconfig_checker,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.diagnostics.fish,
                    null_ls.builtins.diagnostics.hadolint,
                    null_ls.builtins.diagnostics.luacheck,
                    null_ls.builtins.diagnostics.revive,
                    null_ls.builtins.diagnostics.stylelint,
                },
            })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "nvimtools/none-ls.nvim", "williamboman/mason.nvim" },
        opts = {
            ensure_installed = nil,
            automatic_installation = true,
        },
    },
}
