return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- for autocompletion
        "jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        {
            "simrat39/rust-tools.nvim",
            dependencies = { "neovim/nvim-lspconfig" },
        }, -- additional functionality for rust server (e.g. rename file & update imports)
        {
            "saecki/crates.nvim",
            event = { "BufRead Cargo.toml" },
            dependencies = { "nvim-lua/plenary.nvim" },
            config = true,
        },
    },
    config = function()
        local util = require("lspconfig.util")

        local function has_value(tab, val)
            for _, value in ipairs(tab) do
                if value == val then
                    return true
                end
            end
            return false
        end

        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local typescript = require("typescript")
        local mason = require("mason")
        mason.setup()
        local mason_lspconfig = require("mason-lspconfig")

        -- enable keybinds only for when lsp server available
        local on_attach_default = function(client, bufnr)
            print("LS " .. client.name .. " attached")

            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint(bufnr, true)
            end

            local function map(mode, lhs, rhs, opts)
                local options = {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                }
                if opts then
                    options = vim.tbl_extend("force", options, opts)
                end
                vim.keymap.set(mode, lhs, rhs, options)
            end

            -- set keybinds
            map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "Show references" })
            map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to definition" })
            map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to implementation" })
            map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })
            map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Show code actions" })
            map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
            map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostics for current line" })
            map(
                "n",
                "<leader>lD",
                "<cmd>Telescope diagnostics bufnr=0<CR>",
                { desc = "Show diagnostics for current buffer" }
            )
            map("n", "<leader>lgD", vim.diagnostic.goto_prev, { desc = "Jump to previous diagnostic" })
            map("n", "<leader>lgd", vim.diagnostic.goto_next, { desc = "Jump to next diagnostic" })
            map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
            map("n", "<leader>lF", vim.lsp.buf.range_formatting, { desc = "Format selection" })

            -- typescript specific keymaps (e.g. rename file and update imports)
            if client.name == "tsserver" then
                map("n", "<leader>lrf", ":TypescriptRenameFile<CR>", { desc = "Rename file and update imports" })
                map("n", "<leader>loi", ":TypescriptOrganizeImports<CR>", { desc = "Organize imports" })
                map("n", "<leader>lru", ":TypescriptRemoveUnused<CR>", { desc = "Remove unused imports" })
            end

            if client.name == "rust_analyzer" then
                local rt = require("rust-tools")
                rt.inlay_hints.set()
                map("n", "K", rt.rt.hover_actions.hover_actions, { desc = "Show hover actions (rust-tools)" })
                map("n", "<leader>fr", rt.runnables.runnables, { desc = "Show runnables" })
                map("n", "<leader>fd", rt.debuggables.debuggables, { desc = "Show debuggables" })
                map("n", "<leader>lR", ":RustRenameFile<CR>", { desc = "Rename file and update imports" })
                map("n", "<leader>loi", ":RustOrganizeImports<CR>", { desc = "Organize imports" })
                map("n", "<leader>lru", ":RustRemoveUnused<CR>", { desc = "Remove unused imports" })
            end
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local setup_lsp =
            { "lua_ls", "gopls", "rust_analyzer", "jdtls", "tsserver", "astro", "tailwindcss", "pyright", "ccls" }
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if not has_value(setup_lsp, server_name) then
                    table.insert(setup_lsp, server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach_default,
                    })
                end
            end,
        })

        typescript.setup({
            disable_commands = false, -- prevent the plugin from creating Vim commands
            debug = false, -- enable debug logging for commands
            go_to_source_definition = {
                fallback = true, -- fall back to standard LSP definition on failure
            },
            server = {
                capabilities = capabilities,
                on_attach = on_attach_default,
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                        importModuleSpecifierPreference = "non-relative",
                    },
                },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "rust_analyzer", -- rust
                "astro", -- astro
                "tsserver", -- ts/js
                "gopls", -- go
                "html", -- html
                "cssls", -- css, scss, less
                "tailwindcss", -- tailwind
                "lua_ls", -- lua
                "jsonls", -- json
                "marksman", -- markdown
                "yamlls", -- yaml
                "lemminx", -- xml
                "jdtls", -- java
                "pyright", -- python
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure lua server (with special settings)
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            filetypes = { "lua" },
            settings = {
                -- custom settings for lua
                Lua = {
                    hint = {
                        enable = true,
                    },
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        lspconfig.gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl", "WORKSPACE", "WORKSPACE.bazel" },
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    completeUnimported = true,
                    analyses = {
                        unusedparams = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                },
            },
        })

        local rt = require("rust-tools")
        rt.setup({
            tools = {
                runnables = {
                    use_telescope = true,
                },
                inlay_hints = {
                    auto = false,
                },
                cargo = {
                    all_features = true,
                },
            },
            server = {
                on_attach = on_attach_default,
                capabilities = capabilities,
                cmd = { "rustup", "run", "stable", "rust-analyzer" },
                standalone = false,
                settings = {
                    ["rust-analyzer"] = {
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = "crate",
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                        diagnostics = {
                            enable = true,
                            experimental = {
                                enable = true,
                            },
                        },
                    },
                },
            },
            dap = {
                adapter = {
                    type = "executable",
                    command = "lldb-vscode",
                    name = "rt_lldb",
                },
            },
        })
        rt.inlay_hints.enable()

        lspconfig.jdtls.setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            cmd = { "jdtls" },
            filetypes = { "java" },
            root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
            init_options = {
                bundles = {},
            },
            settings = {
                inlayHints = {
                    parameterNames = {
                        enabled = "all",
                    },
                },
                java = {
                    signatureHelp = { enabled = true },
                    eclipse = {
                        downloadSources = true,
                    },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    references = {
                        includeDecompiledSources = true,
                    },
                    inlayHints = {
                        parameterNames = {
                            enabled = "all", -- literals, all, none
                        },
                    },
                    format = {
                        enabled = true,
                    },
                    contentProvider = { preferred = "fernflower" },
                },
            },
        })

        -- configure astro server
        lspconfig["astro"].setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            filetypes = { "astro" },
            settings = {
                astro = {
                    cmd = { "astro-ls", "--stdio" },
                    filetypes = { "astro" },
                    init_options = {
                        configuration = {},
                        typescript = {
                            serverPath = "",
                        },
                    },
                    -- root_dir = lspconfig.util.root_pattern(
                    -- 	"astro.config.mjs",
                    -- 	"astro.config.js",
                    -- 	"astro.config.cjs",
                    -- 	"package.json"
                    -- ),
                },
            },
        })

        -- configure tailwind server
        lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            filetypes = { "astro", "html", "javascriptreact", "typescriptreact", "svelte" },
            settings = {
                tailwindCSS = {
                    files = {
                        exclude = { "node_modules", ".git", "dist", "build", ".cache", ".next" },
                    },
                },
            },
        })

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            filetypes = { "python" },
        })

        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach_default,
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
            javascript = {
                javascript = {
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
                typescript = {
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
            },
        })

        -- configure c/c++ server
        lspconfig.ccls.setup({
            filetypes = { "c", "cpp", "cc", "objc", "objcpp", "opencl" },
            root_dir = function(fname)
                return util.root_pattern(
                    "compile_commands.json",
                    "compile_flags.txt",
                    ".git",
                    "WORKSPACE",
                    "WORKSPACE.bazel"
                )(fname) or util.find_git_ancestor(fname)
            end,
            init_options = {
                cache = {
                    directory = ".ccls-cache",
                },
            },
            capabilities = capabilities,
            on_attach = on_attach_default,
        })
    end,
}
