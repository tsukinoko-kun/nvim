return {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",

    -- My plugins here

    { "kkharji/sqlite.lua" }, -- sqlite3 for lua
    "ericbn/vim-relativize", -- relative line numbers
    "numToStr/Comment.nvim", -- commenting with gc
    "gpanders/editorconfig.nvim", -- editorconfig support
    "nvim-tree/nvim-web-devicons", -- vs-code like icons
    {
        "glepnir/nerdicons.nvim",
        config = true,
        opts = {}
    },    "mbbill/undotree", -- undo tree
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            { "kkharji/sqlite.lua", module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = true,
    },
    {
        "lewis6991/hover.nvim",
        opts = {
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                -- require('hover.providers.man')
                require('hover.providers.dictionary')
            end,
            preview_opts = {
                border = nil,
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
        }
    },
    "ThePrimeagen/harpoon", -- for managing multiple buffers
    {
        "jvgrootveld/telescope-zoxide",
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
        },
    }, -- zoxide integration
    -- "hrsh7th/cmp-buffer",
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end,
    },
    -- snippets
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like icons for autocompletion
    {
        "ellisonleao/glow.nvim",
        config = function()
            require("glow").setup()
        end,
    }, -- markdown preview
    { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter" }, -- autoclose tags
    -- git integration
    "lewis6991/gitsigns.nvim", -- show line modifications on left hand side
    "tpope/vim-fugitive", -- git commands in vim
    "kdheepak/lazygit.nvim", -- lazygit in vim
    "ThePrimeagen/git-worktree.nvim", -- git worktree integration
}
