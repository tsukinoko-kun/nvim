return {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
        formatters_by_ft = {
            javascript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
            typescript = { { "prettierd", "prettier" } },
            typescriptreact = { { "prettierd", "prettier" } },
            json = { { "prettierd", "prettier" } },
            yaml = { { "prettierd", "prettier" } },
            html = { { "prettierd", "prettier" } },
            css = { { "prettierd", "prettier" } },
            scss = { { "prettierd", "prettier" } },
            markdown = { { "prettierd", "prettier" } },
            lua = { "stylua" },
            java = { { "google-java-format", "astyle" } },
            cpp = { { "clang-format", "astyle" } },
            rust = { { "rustfmt", "rustfmt-nightly" } },
            python = { "black" },
            go = { "gofmt" },
        },
    },
}
