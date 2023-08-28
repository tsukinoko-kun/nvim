return {
    "nvimdev/guard.nvim",
    config = function()
        local ft = require("guard.filetype")
        ft("c"):fmt("clang-format"):lint("clang-tidy")
        ft("lua"):fmt("stylua")
        ft("go"):fmt("lsp"):append("golines")
        ft("rust"):fmt("rustfmt")
        ft(
            "astro,javascript,javascriptreact,typescript,typescriptreact,json,jsonc,html,vue,css,scss,less,graphql,markdown,mdx,yaml,java"
        ):fmt("prettier")
        -- npm install -g prettier prettier-plugin-java prettier-plugin-astro

        require("guard").setup({
            fmt_on_save = false,
        })
    end,
}
