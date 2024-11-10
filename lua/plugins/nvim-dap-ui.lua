vim.fn.sign_define("DapBreakpoint", { text = "󰯯", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "󰗖", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)

return {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = {
        "mfussenegger/nvim-dap",
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio",
        "folke/lazydev.nvim",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dapui.setup()
    end,
}
