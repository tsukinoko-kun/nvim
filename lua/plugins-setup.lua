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
    use({
        "catppuccin/nvim",
        as = "catppuccin",
    }) -- preferred colorscheme
    use("ericbn/vim-relativize") -- relative line numbers
    use("numToStr/Comment.nvim") -- commenting with gc
    use("gpanders/editorconfig.nvim") -- editorconfig support

    use("nvim-tree/nvim-tree.lua") -- file explorer
    use("nvim-tree/nvim-web-devicons") -- vs-code like icons
    use({
        "glepnir/nerdicons.nvim",
        cmd = "NerdIcons",
        config = function()
            require("nerdicons").setup({})
        end,
    })

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
                        {
                            icon = "󰚰",
                            desc = " Update",
                            group = "@property",
                            action = "PackerSync",
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
        requires = { "nvim-tree/nvim-web-devicons", "glepnir/nerdicons.nvim" },
    })

    use("nvim-lualine/lualine.nvim") -- statusline

    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim" }) -- fuzzy finder
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
    -- use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lua")
    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
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
        requires = { "neovim/nvim-lspconfig" },
    }) -- additional functionality for rust server (e.g. rename file & update imports)
    use({
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { "nvim-lua/plenary.nvim", "jose-elias-alvarez/null-ls.nvim" },
        config = function()
            require("crates").setup({
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            })
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

    -- debugging
    use("mfussenegger/nvim-dap") -- dap
    use("rcarriga/nvim-dap-ui") -- dap ui
    use("theHamsta/nvim-dap-virtual-text") -- dap virtual text
    use("nvim-telescope/telescope-dap.nvim") -- telescope integration for dap
    use("jay-babu/mason-nvim-dap.nvim") -- mason integration for dap

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
    use("ThePrimeagen/git-worktree.nvim") -- git worktree integration

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
