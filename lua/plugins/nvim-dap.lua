return {
    "mfussenegger/nvim-dap",
    config = function()
        -- keymaps
        local function map(mode, lhs, rhs, opts)
            local options = {
                noremap = true,
                silent = true,
            }
            if opts then
                options = vim.tbl_extend("force", options, opts)
            end
            vim.keymap.set(mode, lhs, rhs, options)
        end
        map("n", "<leader>dc", "<cmd>DapContinue<cr>", {
            desc = "Continue",
        })
        map("n", "<leader>dr", "<cmd>DapRestart<cr>", {
            desc = "Restart",
        })
        map("n", "<leader>do", "<cmd>DapStepOver<cr>", {
            desc = "Step Over",
        })
        map("n", "<leader>di", "<cmd>DapStepInto<cr>", {
            desc = "Step Into",
        })
        map("n", "<leader>dI", "<cmd>DapStepOut<cr>", {
            desc = "Step Out",
        })
        map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", {
            desc = "Toggle Breakpoint",
        })
    end,
}
