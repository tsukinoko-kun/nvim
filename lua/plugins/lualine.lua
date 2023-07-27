return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "f-person/git-blame.nvim",
    },
    config = function()
        local git_blame = require("gitblame")
        vim.g.gitblame_display_virtual_text = 0
        require("lualine").setup({
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { git_blame.get_current_blame_text },
                lualine_y = { "encoding", "fileformat", "filetype" },
                lualine_z = { "location" },
            },
            options = {
                theme = "catppuccin",
                component_separators = { left = "│", right = "│" },
                section_separators = { left = "", right = "" },
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
