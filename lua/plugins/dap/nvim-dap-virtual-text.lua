local virtualtext_status, virtualtext = pcall(require, "nvim-dap-virtual-text")
if not virtualtext_status then
    return
end

virtualtext.setup({
    show_hover = true,
    show_virtual_text = true,
    virtual_text_prefix = "",
    virtual_text_position = "eol",
    virtual_text_lines = 1,
    virtual_text_source = "always",
    virtual_text_current_line_only = false,
    virtual_text_delay = 300,
    virtual_text_mode = "virtual text",
    virtual_text_namespace = vim.api.nvim_create_namespace("nvim-dap-virtual-text"),
    virtual_text_hl_mode = "background",
    virtual_text_hl_id = "Comment",
    virtual_text_hl_namespace = vim.api.nvim_create_namespace("nvim-dap-virtual-text-hl"),
})
