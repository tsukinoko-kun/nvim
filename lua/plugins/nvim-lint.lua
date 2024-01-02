return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            lua = { "luacheck" },
            sh = { "shellcheck" },
            markdown = { "markdownlint" },
            yaml = { "yamllint" },
            json = { "jsonlint" },
            javascript = { "eslint" },
            typescript = { "eslint" },
            typescriptreact = { "eslint" },
            javascriptreact = { "eslint" },
            html = { "tidy" },
            css = { "stylelint" },
            scss = { "stylelint" },
            sass = { "stylelint" },
            less = { "stylelint" },
            go = { "golangcilint" },
            c = { "cppcheck" },
            cpp = { "cppcheck" },
            objc = { "cppcheck" },
            java = { "checkstyle" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({
            "BufEnter",
            "BufWritePost",
            "InsertLeave",
        }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
