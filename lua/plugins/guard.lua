return {
    "nvimdev/guard.nvim",
    dependencies = {
        "nvimdev/guard-collection",
    },
    config = function()
        local ft = require("guard.filetype")
        ft("c"):fmt("clang-format")
        ft("lua"):fmt("stylua")
        ft("go"):fmt("lsp"):append("golines")
        ft("rust"):fmt("rustfmt")
        ft(
            "javascript,javascriptreact,typescript,typescriptreact,json,jsonc,html,vue,css,scss,less,graphql,markdown,mdx,yaml"
        ):fmt("prettier")
        ft(
            "astro"
        ):fmt({
            cmd = "prettier",
            args = { "--plugin=prettier-plugin-astro", "--stdin-filepath" },
            fname = true,
            stdin = true,
        })

        require("guard").setup({
            fmt_on_save = false,
            lsp_as_default_formatter = true,
        })
    end,
}
