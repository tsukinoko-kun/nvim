local includes_one_of = require("utils").includes_one_of

local go_escape_analysis = {
    cmd = "go",
    args = { "build", "-gcflags=-m", "./..." },
    stdin = false,
    append_fname = false,
    stream = "stderr",
    ignore_exitcode = true,
    env = nil,
    parser = function(output, bufnr)
        local diagnostics = {}
        local words = { "moved", "escapes", "heap", "stack" }
        local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")

        for _, line in ipairs(vim.split(output, "\n")) do
            local file, lnum, col, message = string.match(line, "([^:]+):(%d+):(%d+): (.+)")
            if file and lnum and col and message and includes_one_of(message, words) then
                local abs_file = vim.fn.fnamemodify(file, ":p")
                if abs_file == current_file then
                    table.insert(diagnostics, {
                        bufnr = bufnr,
                        lnum = tonumber(lnum) - 1,
                        col = tonumber(col) - 1,
                        message = message,
                        severity = vim.diagnostic.severity.INFO,
                        source = "go_escape_analysis",
                    })
                end
            end
        end

        return diagnostics
    end,
}

return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            lua = { "luacheck" },
            sh = { "shellcheck" },
            -- markdown = { "markdownlint" },
            yaml = { "yamllint" },
            json = { "jsonlint" },
            svelte = {},
            astro = {},
            javascript = {},
            typescript = {},
            typescriptreact = {},
            javascriptreact = {},
            html = { "tidy" },
            css = { "stylelint" },
            scss = { "stylelint" },
            sass = { "stylelint" },
            less = { "stylelint" },
            go = { "golangcilint", "go_escape_analysis" },
            c = { "cppcheck" },
            nix = { "nix" },
            cpp = { "cppcheck" },
            objc = { "cppcheck" },
            -- java = { "checkstyle" },
        }
        lint.linters.go_escape_analysis = go_escape_analysis

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
