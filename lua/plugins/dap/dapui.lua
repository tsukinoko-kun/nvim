local dapui_status, dapui = pcall(require, "dapui")
if not dapui_status then
    return
end

dapui.setup()

local dap_status, dap = pcall(require, "dap")
if not dap_status then
    return
end

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close()
end
