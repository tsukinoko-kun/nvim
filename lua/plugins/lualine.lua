return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "arkav/lualine-lsp-progress",
    },
    config = function()
        require("lualine").setup({
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    function()
                        -- relative file path from project root
                        local filename = vim.fn.expand("%")
                        if vim.bo.readonly then
                            filename = filename .. " [RO]"
                        end
                        if vim.bo.modified then
                            filename = filename .. " [+]"
                        end
                        return filename
                    end,
                    "lsp_progress",
                },
                lualine_y = {
                    "encoding",
                    "fileformat",
                    {
                        "filetype",
                        colored = false,
                        icon_only = false,
                    },
                },
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
