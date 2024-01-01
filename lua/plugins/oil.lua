return {
    "stevearc/oil.nvim",
    opts = {
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
            "icon",
            -- "permissions",
            -- "size",
            -- "mtime",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
            buflisted = false,
            bufhidden = "hide",
        },
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
        default_file_explorer = true,
        -- Restore window options to previous values when leaving an oil buffer
        restore_win_options = true,
        -- Skip the confirmation popup for simple operations
        skip_confirm_for_simple_edits = true,
        -- Deleted files will be removed with the trash_command (below).
        delete_to_trash = false,
        keymaps = {
            ["<leader>?"] = "actions.show_help",
            ["<leader>."] = "actions.toggle_hidden",
        },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
