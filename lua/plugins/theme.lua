return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = require("utils").get_appearance_mode() == "dark" and "mocha" or "latte",
        show_end_of_buffer = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = false,
            mini = false,
            harpoon = true,
            mason = true,
            which_key = true,
        },
    },
}
