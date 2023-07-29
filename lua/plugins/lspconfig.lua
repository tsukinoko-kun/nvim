return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- for autocompletion
        "jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
        "p00f/clangd_extensions.nvim", -- additional functionality for clangd server (e.g. rename file & update imports)
        "williamboman/mason-lspconfig.nvim",
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
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local typescript = require("typescript")

        -- enable keybinds only for when lsp server available
        local on_attach = function(client, bufnr)
            print("LS " .. client.name .. " attached")

            -- if client.server_capabilities.inlayHintProvider then
            --     vim.lsp.buf.inlay_hint(bufnr, true)
            -- end

            local function map(mode, lhs, rhs, opts)
                local options = { noremap = true, silent = true, buffer = bufnr }
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
            map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<cr>", { desc = "Show code actions" })
            map("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", { desc = "Rename symbol" })
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

            -- c / c++ specific keymaps (e.g. toggle header/source)
            if client.name == "clangd" then
                map("n", "gh", ":ClangdSwitchSourceHeader<CR>", { desc = "Toggle header/source" })
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

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
        })

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = "", Warn = "", Hint = "", Info = "" }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure html server
        lspconfig["html"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure css server
        lspconfig["cssls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
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

        lspconfig["gopls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    completeUnimported = true,
                    analyses = {
                        unusedparams = true,
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
                    auto = true,
                    only_current_line = false,
                    show_parameter_hints = true,
                    max_len_align = false,
                    max_len_align_padding = 1,
                    highlight = "Comment",
                },
                cargo = {
                    all_features = true,
                },
            },
            server = {
                on_attach = on_attach,
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
            on_attach = on_attach,
            cmd = { "jdtls" },
            filetypes = { "java" },
            root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
            init_options = {
                bundles = {},
            },
            settings = {
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

        lspconfig.gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                gopls = {
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

        -- configure typescript server with plugin
        typescript.setup({
            server = {
                capabilities = capabilities,
                on_attach = on_attach,
            },
        })

        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
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
        })

        -- configure astro server
        lspconfig["astro"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
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

        -- configure python server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "python" },
        })

        -- configure c/c++ server
        lspconfig["clangd"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                clangd = {
                    compileCommandsDir = "build",
                    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
                        or lspconfig.util.path.dirname,
                    filetypes = { "c", "h", "hpp", "cpp", "cpi", "objc", "objcpp" },
                    single_file_support = true,
                },
            },
        })
        require("clangd_extensions").setup({
            server = { capabilities = capabilities, on_attach = on_attach },
            extensions = {
                -- defaults:
                -- Automatically set inlay hints (type hints)
                autoSetHints = true,
                -- These apply to the default ClangdSetInlayHints command
                inlay_hints = {
                    inline = vim.fn.has("nvim-0.10") == 1,
                    -- Only show inlay hints for the current line
                    only_current_line = false,
                    -- Event which triggers a refersh of the inlay hints.
                    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                    -- not that this may cause  higher CPU usage.
                    -- This option is only respected when only_current_line and
                    -- autoSetHints both are true.
                    only_current_line_autocmd = "CursorHold",
                    -- whether to show parameter hints with the inlay hints or not
                    show_parameter_hints = true,
                    -- prefix for parameter hints
                    parameter_hints_prefix = "<- ",
                    -- prefix for all the other hints (type, chaining)
                    other_hints_prefix = "=> ",
                    -- whether to align to the length of the longest line in the file
                    max_len_align = false,
                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 1,
                    -- whether to align to the extreme right or not
                    right_align = false,
                    -- padding from the right if right_align is true
                    right_align_padding = 7,
                    -- The color of the hints
                    highlight = "Comment",
                    -- The highlight group priority for extmark
                    priority = 100,
                },
                ast = {
                    role_icons = {
                        type = "",
                        declaration = "",
                        expression = "",
                        specifier = "",
                        statement = "",
                        ["template argument"] = "",
                    },
                    kind_icons = {
                        Compound = "",
                        Recovery = "",
                        TranslationUnit = "",
                        PackExpansion = "",
                        TemplateTypeParm = "",
                        TemplateTemplateParm = "",
                        TemplateParamObject = "",
                    },
                    highlights = {
                        detail = "Comment",
                    },
                },
                memory_usage = {
                    border = "none",
                },
                symbol_info = {
                    border = "none",
                },
            },
        })
    end,
}
