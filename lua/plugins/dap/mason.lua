local mason_dap_status, mason_dap = pcall(require, "mason-nvim-dap")
if not mason_dap_status then
    return
end

mason_dap.setup({
    ensure_installed = {
        "codelldb",
        "cpptools",
        "delve",
        "java-debug-adaptor",
        "java-test",
    },
    -- auto-install configured debuggers (with nvim-dap)
    automatic_installation = true, -- not the same as ensure_installed
})
