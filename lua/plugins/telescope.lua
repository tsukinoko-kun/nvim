return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
        { "nvim-telescope/telescope-ui-select.nvim" }, -- for showing lsp code actions
        { "simrat39/symbols-outline.nvim", config = true }, -- for showing symbols outline
    },
    init = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local themes = require("telescope.themes")
        telescope.setup({
            defaults = {
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        hidden = true,
                    },
                },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                    },
                },
                file_ignore_patterns = {
                    "^.git/",
                    "^.cache/",
                    "^node_modules/",
                },
            },
            extensions = {
                ["ui-select"] = {
                    themes.get_dropdown({}),
                },
            },
        })
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("harpoon")
        telescope.load_extension("zoxide")
        telescope.load_extension("neoclip")
    end,
}
