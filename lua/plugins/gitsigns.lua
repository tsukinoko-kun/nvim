return {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "│" },
            topdelete = { text = "│" },
            changedelete = { text = "│" },
            untracked = { text = "┆" },
        },
    },
}
