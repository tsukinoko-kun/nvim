return {
    "zbirenbaum/copilot.lua",
    opts = {
        suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-y>" } },
        panel = {
            enabled = false,
        },
        filetypes = {
            markdown = true,
            help = true,
        },
    },
}
