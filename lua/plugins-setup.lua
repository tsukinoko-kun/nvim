local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
   "wbthomason/packer.nvim",

    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",

    -- My plugins here

    { "kkharji/sqlite.lua" }, -- sqlite3 for lua
    {
        "catppuccin/nvim",
        name = "catppuccin",
    }, -- preferred colorscheme
    "ericbn/vim-relativize", -- relative line numbers
    "numToStr/Comment.nvim", -- commenting with gc
    "gpanders/editorconfig.nvim", -- editorconfig support

    "prichrd/netrw.nvim", -- file explorer
    "nvim-tree/nvim-web-devicons", -- vs-code like icons
    {
        "glepnir/nerdicons.nvim",
        cmd = "NerdIcons",
        config = function()
            require("nerdicons").setup({})
        end,
    },

    "nvim-lualine/lualine.nvim", -- statusline

    "mbbill/undotree", -- undo tree

    -- fuzzy finding w/ telescope
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
    { "nvim-telescope/telescope.nvim" }, -- fuzzy finder
    { "nvim-telescope/telescope-ui-select.nvim" }, -- for showing lsp code actions
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            { "kkharji/sqlite.lua", module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("neoclip").setup()
        end,
    },
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup({
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    -- require('hover.providers.gh')
                    -- require('hover.providers.gh_user')
                    -- require('hover.providers.jira')
                    -- require('hover.providers.man')
                    -- require('hover.providers.dictionary')
                end,
                preview_opts = {
                    border = nil,
                },
                -- Whether the contents of a currently open hover window should be moved
                -- to a :h preview-window when pressing the hover keymap.
                preview_window = false,
                title = true,
            })
        end,
    },
    "ThePrimeagen/harpoon", -- for managing multiple buffers

    {
        "jvgrootveld/telescope-zoxide",
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
        },
    }, -- zoxide integration

    -- autocomplete
    "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end,
    },

    -- snippets
    "L3MON4D3/LuaSnip", -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets

    -- managing & installing lsp servers, linters & formatters
    "williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
    "williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig

    -- configuring lsp servers
    "neovim/nvim-lspconfig", -- easily configure language servers
    "hrsh7th/cmp-nvim-lsp", -- for autocompletion
    "jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
    "p00f/clangd_extensions.nvim", -- additional functionality for clangd server (e.g. rename file & update imports)
    {
        "simrat39/rust-tools.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
    }, -- additional functionality for rust server (e.g. rename file & update imports)
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim", "jose-elias-alvarez/null-ls.nvim" },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
        end,
    },
    "onsails/lspkind.nvim", -- vs-code like icons for autocompletion
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
        end,
    },

    -- formatting & linting
    "jose-elias-alvarez/null-ls.nvim",
    "jayp0521/mason-null-ls.nvim",

    -- debugging
    "mfussenegger/nvim-dap", -- dap
    "rcarriga/nvim-dap-ui", -- dap ui
    "theHamsta/nvim-dap-virtual-text", -- dap virtual text
    "nvim-telescope/telescope-dap.nvim", -- telescope integration for dap
    "jay-babu/mason-nvim-dap.nvim", -- mason integration for dap

    -- treesitter configuration
    "nvim-treesitter/nvim-treesitter-context",
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    },
    "norcalli/nvim-colorizer.lua", -- colorize hex codes
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
})
