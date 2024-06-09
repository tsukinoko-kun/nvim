local setup_lsp = { "lua_ls", "gopls", "htmx", "jdtls", "astro", "tailwindcss", "ccls" }

local function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- enable keybinds only for when lsp server available
local on_attach_default = function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end

    local function map(mode, lhs, rhs, opts)
        if rhs == nil then
            print("No rhs for " .. opts.desc)
            return
        end
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
    map("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show diagnostics for current buffer" })
    map("n", "<leader>lgD", vim.diagnostic.goto_prev, { desc = "Jump to previous diagnostic" })
    map("n", "<leader>lgd", vim.diagnostic.goto_next, { desc = "Jump to next diagnostic" })
    map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == "typescript-tools" then
        map("n", "<leader>lrf", ":TSToolsRenameFile<CR>", { desc = "Rename file and update imports" })
        map("n", "<leader>loi", ":TSToolsOrganizeImports<CR>", { desc = "Organize imports" })
        map("n", "<leader>lru", ":TSToolsRemoveUnused<CR>", { desc = "Remove unused imports" })
        map("n", "gs", ":TSToolsGoToSourceDefinition<CR>", { desc = "Go to source definition" })
    end

    -- go specific keymaps (e.g. rename file and update imports)
    if client.name == "gopls" then
        require("core.format").set_format_on_save(true)
    end
end

return {
    {
        "williamboman/mason.nvim",
        config = true,
    },

    {
        "pmizio/typescript-tools.nvim",
        ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            on_attach = on_attach_default,
            settings = {
                publish_diagnostic_on = "change",
                tsserver_locale = "en",
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeCompletionsForModuleExports = true,
                    quotePreference = "auto",
                },
                tsserver_format_options = {
                    allowIncompleteCompletions = false,
                    allowRenameOfImportPath = false,
                },
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup_handlers({
                function(server_name)
                    if not has_value(setup_lsp, server_name) then
                        table.insert(setup_lsp, server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = require("cmp_nvim_lsp").default_capabilities(),
                            on_attach = on_attach_default,
                        })
                    end
                end,
            })
            mason_lspconfig.setup({
                -- list of servers for mason to install
                ensure_installed = {
                    "astro", -- astro
                    "svelte", -- svelte
                    "gopls", -- go
                    "templ", -- html templating
                    "htmx", -- htmx
                    "html", -- html
                    "cssls", -- css, scss, less
                    "tailwindcss", -- tailwind
                    "lua_ls", -- lua
                    "jsonls", -- json
                    "marksman", -- markdown
                    "yamlls", -- yaml
                    "lemminx", -- xml
                    "jdtls", -- java
                    "csharp_ls", -- C#
                    "biome", -- JS Linter
                },
                -- auto-install configured servers (with lspconfig)
                automatic_installation = true, -- not the same as :ensure_installed
            })
            vim.filetype.add({ extension = { templ = "templ", razor = "razor", cshtml = "cshtml" } })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local util = require("lspconfig.util")
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()

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
                        runtime = {
                            version = "LuaJIT",
                        },
                        hint = {
                            enable = true,
                        },
                        -- make the language server recognize "vim" global
                        diagnostics = {
                            globals = { "vim", "Yab" },
                        },
                        workspace = {
                            checkThirdParty = false, -- disable checking for third party libraries
                            -- make language server aware of runtime files
                            library = {
                                vim.env.VIMRUNTIME,
                                vim.fn.expand("$VIMRUNTIME/lua"),
                                vim.fn.stdpath("config") .. "/lua",
                                vim.fn.expand("$XDG_CONFIG_HOME/yab/lib"),
                            },
                        },
                    },
                },
            })

            lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = on_attach_default,
                cmd = { "gopls" },
                filetypes = { "go", "mod" },
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

            lspconfig.htmx.setup({
                on_attach = on_attach_default,
                capabilities = capabilities,
                filetypes = { "html", "templ" },
            })

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
                    },
                },
            })

            -- configure tailwind server
            lspconfig["tailwindcss"].setup({
                capabilities = capabilities,
                on_attach = on_attach_default,
                filetypes = { "astro", "templ", "html", "javascriptreact", "typescriptreact", "svelte" },
                init_options = { userLanguages = { templ = "html" } },
                settings = {
                    tailwindCSS = {
                        files = {
                            exclude = { "node_modules", ".git", "dist", "build", ".cache", ".next" },
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
    },
}
