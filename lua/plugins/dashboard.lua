return {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
        require("dashboard").setup({
            shortcut_type = "number",
            config = {
                header = {
                    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
                    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
                    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
                    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
                    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
                    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
                },
                shortcut = {
                    {
                        icon = "󰚰",
                        desc = " Update",
                        group = "@property",
                        action = "Lazy sync",
                        key = "u",
                    },
                    {
                        icon = "󰥨",
                        desc = " Files",
                        group = "Label",
                        action = "Telescope find_files",
                        key = "f",
                    },
                    {
                        icon = "󰿅",
                        desc = " Quit",
                        group = "Label",
                        action = "quit",
                        key = "q",
                    },
                },
            },
        })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
