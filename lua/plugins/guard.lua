return {
    "nvimdev/guard.nvim",
    config = function()
        local ft = require("guard.filetype")
        ft("c"):fmt("clang-format"):lint("clang-tidy")
        ft("lua"):fmt("stylua")
        ft("go"):fmt("lsp"):append("golines")
        ft("rust"):fmt("rustfmt")
        ft("javascript,typescript"):fmt("prettier")

        require("guard").setup({
            -- the only option for the setup function
            fmt_on_save = false,
        })
    end,
}
