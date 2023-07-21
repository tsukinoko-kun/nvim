return {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",

    -- My plugins here

    { "github/copilot.vim" },
    { "kkharji/sqlite.lua" },                      -- sqlite3 for lua
    "ericbn/vim-relativize",                       -- relative line numbers
    { "numToStr/Comment.nvim",  config = true },   -- commenting with gc
    "gpanders/editorconfig.nvim",                  -- editorconfig support
    "nvim-tree/nvim-web-devicons",                 -- vs-code like icons
    "sitiom/nvim-numbertoggle",                    -- toggle relative line numbers
    {
        "glepnir/nerdicons.nvim",
        config = true,
        opts = {},
    },
    "mbbill/undotree", -- undo tree
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            { "kkharji/sqlite.lua",           module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = true,
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
        config = true,
    },
    -- snippets
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim",         -- vs-code like icons for autocompletion
    {
        "ellisonleao/glow.nvim",
        config = true,
    },                                                              -- markdown preview
    { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter" }, -- autoclose tags
    -- git integration
    "lewis6991/gitsigns.nvim",                                      -- show line modifications on left hand side
    "tpope/vim-fugitive",                                           -- git commands in vim
    "kdheepak/lazygit.nvim",                                        -- lazygit in vim
    "ThePrimeagen/git-worktree.nvim",                               -- git worktree integration
    "mg979/vim-visual-multi",
}
