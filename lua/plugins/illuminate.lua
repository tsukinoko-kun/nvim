return {
    "RRethy/vim-illuminate",
    config = function()
        require("illuminate").configure({
            providers = {
                "lsp",
                "treesitter",
            },
            delay = 100,
            under_cursor = true,
            min_count_to_highlight = 2,
        })
        vim.cmd("highlight! link IlluminatedWordText IncSearch")
        vim.cmd("highlight! link IlluminatedWordRead IncSearch")
        vim.cmd("highlight! link IlluminatedWordWrite IncSearch")
    end,
}
