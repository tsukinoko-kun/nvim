return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
    end,
    -- configure treesitter
    config = function()
        local ts = require("nvim-treesitter.configs")
        ts.setup({
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Select around function" },
                        ["if"] = { query = "@function.inner", desc = "Select inside function" },
                        ["at"] = { query = "@class.outer", desc = "Select around type" },
                        ["it"] = { query = "@class.inner", desc = "Select inner part of a type region" },
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        ["is"] = {
                            query = "@scope.inner",
                            query_group = "locals",
                            desc = "Select inner language scope",
                        },
                        ["ac"] = { query = "@conditional.outer", desc = "Select around conditional" },
                        ["ic"] = { query = "@conditional.inner", desc = "Select inside conditional" },
                        ["al"] = { query = "@loop.outer", desc = "Select around loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
                        ["a#"] = { query = "@comment.outer", desc = "Select around comment" },
                        ["i#"] = { query = "@comment.inner", desc = "Select inside comment" },
                        ["aF"] = { query = "@call.outer", desc = "Select around function call" },
                        ["iF"] = { query = "@call.inner", desc = "Select inside function call" },
                        ["a,"] = { query = "@parameter.outer", desc = "Select around parameter" },
                        ["i,"] = { query = "@parameter.inner", desc = "Select inside parameter" },
                        ["a/"] = { query = "@parameter.outer", kind = "regex", desc = "Select around parameter" },
                        ["i/"] = { query = "@parameter.inner", kind = "regex", desc = "Select inside parameter" },
                        ["a*"] = { query = "@parameter.outer", kind = "glob", desc = "Select around parameter" },
                        ["i*"] = { query = "@parameter.inner", kind = "glob", desc = "Select inside parameter" },
                    },
                    include_surrounding_whitespace = false,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = { query = "@parameter.inner", desc = "Swap next" },
                    },
                    swap_previous = {
                        ["<leader>A"] = { query = "@parameter.inner", desc = "Swap previous" },
                    },
                },
            },
            -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = { enable = true },
            -- ensure these language parsers are installed
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "markdown",
                "markdown_inline",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "rust",
                "go",
            },
            -- auto install above language parsers
            auto_install = true,
        })

        -- add textobject mappings
        local actions = { "Change", "Delete", "Yank", "Cut" }
        local action_keys = { "c", "d", "y", "x" }
        local map = function(select, desc)
            local options = { noremap = true, silent = true }
            for i, action_desc in ipairs(actions) do
                local action = action_keys[i]
                local opts = vim.tbl_extend("force", options, { desc = action_desc .. " " .. desc })
                local lhs = action .. select
                local rhs = ":normal v" .. select .. "<CR>" .. action
                vim.keymap.set("n", lhs, rhs, opts)
            end
        end

        map("af", "around function")
        map("if", "inside function")
        map("at", "around type")
        map("it", "inner part of a type region")
        map("as", "language scope")
        map("is", "inner language scope")
        map("ac", "around conditional")
        map("ic", "inside conditional")
        map("al", "around loop")
        map("il", "inside loop")
        map("a#", "around comment")
        map("i#", "inside comment")
        map("aF", "around function call")
        map("iF", "inside function call")
        map("a,", "around parameter")
        map("i,", "inside parameter")
        map("a/", "around parameter")
        map("i/", "inside parameter")
        map("a*", "around parameter")
        map("i*", "inside parameter")

        require("treesitter-context").setup({
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
            trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
            on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        })
    end,
}
