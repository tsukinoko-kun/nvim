local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)
    use("wbthomason/packer.nvim")

    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")

    -- My plugins here

    use({ "kkharji/sqlite.lua" }) -- sqlite3 for lua
    use("EdenEast/nightfox.nvim") -- preferred colorscheme
    use("ericbn/vim-relativize") -- relative line numbers
    use("numToStr/Comment.nvim") -- commenting with gc
    use("gpanders/editorconfig.nvim") -- editorconfig support

    use("nvim-tree/nvim-tree.lua") -- file explorer
    use("nvim-tree/nvim-web-devicons") -- vs-code like icons

    use({
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({
                theme = "hyper",
                shortcut_type = "number",
                config = {
                    week_header = {
                        enable = true,
                    },
                    shortcut = {
                        { desc = " Update", group = "@property", action = "PackerSync", key = "u" },
                        {
                            icon = " ",
                            icon_hl = "@variable",
                            desc = "Files",
                            group = "Label",
                            action = "Telescope find_files",
                            key = "f",
                        },
                        {
                            icon = " ",
                            icon_hl = "@error",
                            desc = "Quit",
                            group = "Label",
                            action = "quit",
                            key = "q",
                        },
                    },
                },
            })
        end,
        requires = { "nvim-tree/nvim-web-devicons" },
    })

    use("nvim-lualine/lualine.nvim") -- statusline

    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
    use({ "nvim-telescope/telescope-ui-select.nvim" }) -- for showing lsp code actions
    use({
        "AckslD/nvim-neoclip.lua",
        requires = {
            { "kkharji/sqlite.lua", module = "sqlite" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("neoclip").setup()
        end,
    })
    use({
        "JASONews/glow-hover",
        requires = {
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("glow-hover").setup({
                max_width = 50,
                padding = 10,
                border = "shadow",
                glow_path = "glow",
            })
        end,
    })

    use("ThePrimeagen/harpoon") -- for managing multiple buffers

    use({
        "jvgrootveld/telescope-zoxide",
        requires = {
            { "nvim-telescope/telescope.nvim" },
        },
    }) -- zoxide integration

    -- autocomplete
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lua")
    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            })
        end,
    })

    -- snippets
    use("L3MON4D3/LuaSnip") -- snippet engine
    use("saadparwaiz1/cmp_luasnip") -- for autocompletion
    use("rafamadriz/friendly-snippets") -- useful snippets

    -- managing & installing lsp servers, linters & formatters
    use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
    use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

    -- configuring lsp servers
    use("neovim/nvim-lspconfig") -- easily configure language servers
    use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
    use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
    use("p00f/clangd_extensions.nvim") -- additional functionality for clangd server (e.g. rename file & update imports)
    use({
        "simrat39/rust-tools.nvim",
        ft = "rust",
    }) -- additional functionality for rust server (e.g. rename file & update imports)
    use({
        "saecki/crates.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end,
    })
    use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
    use({
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup()
        end,
    })

    -- formatting & linting
    use("jose-elias-alvarez/null-ls.nvim")
    use("jayp0521/mason-null-ls.nvim")

    -- treesitter configuration
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
            ts_update()
        end,
    })
    use("norcalli/nvim-colorizer.lua") -- colorize hex codes
    use({
        "ellisonleao/glow.nvim",
        config = function()
            require("glow").setup()
        end,
    }) -- markdown preview

    -- auto closing
    use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
    use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- git integration
    use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side
    use("tpope/vim-fugitive") -- git commands in vim
    use("kdheepak/lazygit.nvim") -- lazygit in vim

    use({
        "github/copilot.vim",
        config = function()
            vim.g.copilot_enabled = 1
        end,
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)
