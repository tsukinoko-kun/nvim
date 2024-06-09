local table_set = require("utils").table_set
local table_has = require("utils").table_has
local file_exists = require("utils").file_exists

function AutoForm()
    local js_format = {}
    local css_format = {}
    local json_format = {}
    local astro_format = {}

    local prettier_used = false
    local eslint_used = false

    -- biome
    local biomeConfFile = io.open("biome.json", "r")
    if biomeConfFile ~= nil then
        local biomeConfStr = biomeConfFile:read("*all")
        io.close(biomeConfFile)
        local biomeConf = vim.json.decode(biomeConfStr)

        if biomeConf.linter ~= nil and biomeConf.linter.enabled == true then
            table_set(js_format, "biome-check")
            table_set(css_format, "biome-check")
            table_set(json_format, "biome-check")
        elseif biomeConf.javascript ~= nil and biomeConf.javascript.linter then
            table_set(js_format, "biome-check")
        elseif biomeConf.json ~= nil and biomeConf.json.linter then
            table_set(json_format, "biome-check")
        elseif biomeConf.css ~= nil and biomeConf.json.linter then
            table_set(js_format, "biome-check")
        end

        if
            biomeConf.javascript ~= nil
            and biomeConf.javascript.globals ~= nil
            and table_has(biomeConf.javascript.globals, "Astro")
        then
            table_set(astro_format, "biome-check")
        end
    end

    -- prettier
    if
        file_exists(".prettierignore")
        or file_exists(".prettierrc")
        or file_exists(".prettierrc.json")
        or file_exists(".prettierrc.yml")
        or file_exists(".prettierrc.yaml")
        or file_exists(".prettierrc.json5")
        or file_exists(".prettierrc.js")
        or file_exists(".prettierrc.cjs")
        or file_exists(".prettierrc.mjs")
        or file_exists(".prettierrc.toml")
        or file_exists("prettier.config.js")
        or file_exists("prettier.config.mjs")
        or file_exists("prettier.config.cjs")
    then
        prettier_used = true
        table_set(js_format, "prettierd")
        table_set(json_format, "prettierd")
        table_set(css_format, "prettierd")
        table_set(astro_format, "prettierd")
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
        eslint_used = true
        table_set(js_format, "eslint_d")
        table_set(json_format, "eslint_d")
        table_set(css_format, "eslint_d")
        table_set(astro_format, "eslint_d")
    end

    -- package.json
    local packageJsonFile = io.open("package.json", "r")
    if packageJsonFile ~= nil then
        local packageJsonStr = packageJsonFile:read("*all")
        io.close(packageJsonFile)
        local packageJson = vim.json.decode(packageJsonStr)
        if packageJson.prettier ~= nil then
            table_set(js_format, "prettierd")
            table_set(json_format, "prettierd")
            table_set(css_format, "prettierd")
            table_set(astro_format, "prettierd")
        end
    end

    local def = {}

    if prettier_used then
        table_set(def, "prettierd")
    else
        table_set(def, "prettier")
    end

    if eslint_used then
        table_set(def, "eslint_d")
    else
        table_set(def, "eslint")
    end

    local formatters_by_ft = {
        astro = astro_format,
        javascript = js_format,
        typescript = js_format,
        typescriptreact = js_format,
        json = json_format,
        css = css_format,
        scss = css_format,
        yaml = def,
        html = def,
        markdown = def,
        lua = { "stylua" },
        java = { "google-java-format" },
        cpp = { { "clang-format", "astyle" } },
        c = { { "clang-format", "astyle" } },
        rust = { { "rustfmt", "rustfmt-nightly" } },
        python = { "black" },
        go = { "goimports", "gofmt" },
        templ = { "templ" },
        cs = { "csharpier" },
    }

    return formatters_by_ft
end

return {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
        formatters_by_ft = AutoForm(),
    },
}
