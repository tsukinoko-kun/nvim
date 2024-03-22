return {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
        filesize = 2, -- in MiB
    },
}
