local mouse = vim.opt.mouse

return {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
        "mfussenegger/nvim-dap",
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
            mouse = vim.opt.mouse
            vim.opt.mouse = "nvi"
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
            vim.opt.mouse = mouse
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
            vim.opt.mouse = mouse
        end
    end,
}
