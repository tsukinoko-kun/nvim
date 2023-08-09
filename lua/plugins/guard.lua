return {
    "nvimdev/guard.nvim",
    config = function()
        local ft = require("guard.filetype")
        ft("c"):fmt("clang-format"):lint("clang-tidy")
        ft("lua"):fmt("stylua")
        ft("go"):fmt("lsp"):append("golines")
        ft("rust"):fmt("rustfmt")
        ft(
            "astro,javascript,javascriptreact,typescript,typescriptreact,json,jsonc,html,vue,css,scss,less,graphql,markdown,mdx,yaml"
        ):fmt("prettier")

        require("guard").setup({
            -- the only option for the setup function
            fmt_on_save = false,
        })
    end,
}
