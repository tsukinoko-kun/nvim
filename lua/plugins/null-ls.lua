return {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting   -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters
        null_ls.setup({
            -- setup formatters & linters
            sources = {
                formatting.prettier.with({
                    -- indent size 4 spaces, trailing comma
                    extra_args = { "--tab-width", "4", "--trailing-comma", "all" },
                }),
                formatting.stylua, -- lua formatter
                formatting.clang_format.with({
                    -- indent size 4 spaces
                    extra_args = { "--style", "{BasedOnStyle: LLVM, IndentWidth: 4}" },
                }),                            -- c/c++ formatter
                formatting.google_java_format, -- java formatter
                formatting.rustfmt,            -- rust formatter
                formatting.eslint_d.with({
                    -- js/ts linter
                    condition = function(utils)
                        -- only if eslint config file is present
                        return utils.root_has_file(".eslintrc.js")
                            or utils.root_has_file(".eslintrc.cjs")
                            or utils.root_has_file(".eslintrc.yaml")
                            or utils.root_has_file(".eslintrc.yml")
                            or utils.root_has_file(".eslintrc.json")
                    end,
                }),
                diagnostics.eslint_d.with({
                    -- js/ts linter
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
                diagnostics.mypy,     --python
                diagnostics.ruff,     --python
            },
        })
    end,
}
