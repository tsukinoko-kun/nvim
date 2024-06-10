local table_set = require("utils").table_set
local table_has = require("utils").table_has
local file_exists = require("utils").file_exists

function AutoLint()
    local linters_by_ft = {
        lua = { "luacheck" },
        sh = { "shellcheck" },
        markdown = { "markdownlint" },
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
        go = { "golangcilint" },
        c = { "cppcheck" },
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
        table_set(linters_by_ft.json, "eslint_d")
        table_set(linters_by_ft.css, "eslint_d")
        table_set(linters_by_ft.scss, "eslint_d")
        table_set(linters_by_ft.javascript, "eslint_d")
        table_set(linters_by_ft.javascriptreact, "eslint_d")
        table_set(linters_by_ft.typescript, "eslint_d")
        table_set(linters_by_ft.typescriptreact, "eslint_d")
        table_set(linters_by_ft.svelte, "eslint_d")
        table_set(linters_by_ft.astro, "eslint_d")
    end

    -- package.json
    local packageJsonFile = io.open("package.json", "r")
    if packageJsonFile ~= nil then
        local packageJsonStr = packageJsonFile:read("*all")
        io.close(packageJsonFile)
        local packageJson = vim.json.decode(packageJsonStr)
        if packageJson.eslintConfig ~= nil then
            table_set(linters_by_ft.json, "eslint_d")
            table_set(linters_by_ft.css, "eslint_d")
            table_set(linters_by_ft.scss, "eslint_d")
            table_set(linters_by_ft.javascript, "eslint_d")
            table_set(linters_by_ft.javascriptreact, "eslint_d")
            table_set(linters_by_ft.typescript, "eslint_d")
            table_set(linters_by_ft.typescriptreact, "eslint_d")
            table_set(linters_by_ft.svelte, "eslint_d")
            table_set(linters_by_ft.astro, "eslint_d")
        end
    end

    return linters_by_ft
end

return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = AutoLint()

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
