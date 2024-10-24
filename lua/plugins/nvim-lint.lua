local table_set = require("utils").table_set
local table_has = require("utils").table_has
local file_exists = require("utils").file_exists

function AutoLint()
    local linters_by_ft = {
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
        java = { "checkstyle" },
    }

    -- biome
    local biomeConfFile = io.open("biome.json", "r")
    if biomeConfFile ~= nil then
        local biomeConfStr = biomeConfFile:read("*all")
        io.close(biomeConfFile)
        local biomeConf = vim.json.decode(biomeConfStr)

        if biomeConf.linter ~= nil and biomeConf.linter.enabled == true then
            table_set(linters_by_ft.json, "biomejs")
            table_set(linters_by_ft.css, "biomejs")
            table_set(linters_by_ft.scss, "biomejs")
            table_set(linters_by_ft.javascript, "biomejs")
            table_set(linters_by_ft.javascriptreact, "biomejs")
            table_set(linters_by_ft.typescript, "biomejs")
            table_set(linters_by_ft.typescriptreact, "biomejs")
            table_set(linters_by_ft.svelte, "biomejs")
        elseif biomeConf.javascript ~= nil and biomeConf.javascript.linter then
            table_set(linters_by_ft.javascript, "biomejs")
            table_set(linters_by_ft.javascriptreact, "biomejs")
            table_set(linters_by_ft.typescript, "biomejs")
            table_set(linters_by_ft.typescriptreact, "biomejs")
        elseif biomeConf.json ~= nil and biomeConf.json.linter then
            table_set(linters_by_ft.json, "biomejs")
        elseif biomeConf.css ~= nil and biomeConf.json.linter then
            table_set(linters_by_ft.css, "biomejs")
            table_set(linters_by_ft.scss, "biomejs")
        end

        if
            biomeConf.javascript ~= nil
            and biomeConf.javascript.globals ~= nil
            and table_has(biomeConf.javascript.globals, "Astro")
        then
            table.insert(linters_by_ft.astro, "biomejs")
        end
    end

    -- eslint
    if
        file_exists(".eslintrc.js")
        or file_exists(".eslintrc.cjs")
        or file_exists(".eslintrc.mjs")
        or file_exists("eslint.config.js")
        or file_exists("eslint.config.mjs")
        or file_exists("eslint.config.cjs")
    then
        table_set(linters_by_ft.json, "eslint")
        table_set(linters_by_ft.css, "eslint")
        table_set(linters_by_ft.scss, "eslint")
        table_set(linters_by_ft.javascript, "eslint")
        table_set(linters_by_ft.javascriptreact, "eslint")
        table_set(linters_by_ft.typescript, "eslint")
        table_set(linters_by_ft.typescriptreact, "eslint")
        table_set(linters_by_ft.svelte, "eslint")
        table_set(linters_by_ft.astro, "eslint")
    end

    -- package.json
    local packageJsonFile = io.open("package.json", "r")
    if packageJsonFile ~= nil then
        local packageJsonStr = packageJsonFile:read("*all")
        io.close(packageJsonFile)
        local packageJson = vim.json.decode(packageJsonStr)
        if packageJson.eslintConfig ~= nil then
            table_set(linters_by_ft.json, "eslint")
            table_set(linters_by_ft.css, "eslint")
            table_set(linters_by_ft.scss, "eslint")
            table_set(linters_by_ft.javascript, "eslint")
            table_set(linters_by_ft.javascriptreact, "eslint")
            table_set(linters_by_ft.typescript, "eslint")
            table_set(linters_by_ft.typescriptreact, "eslint")
            table_set(linters_by_ft.svelte, "eslint")
            table_set(linters_by_ft.astro, "eslint")
        end
    end

    return linters_by_ft
end

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
        lint.linters_by_ft = AutoLint()
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
