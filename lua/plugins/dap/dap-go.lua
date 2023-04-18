local dapgo_status, dapgo = pcall(require, "dap-go")
if not dapgo_status then
    return
end

dapgo.setup()
