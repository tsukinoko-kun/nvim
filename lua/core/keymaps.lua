vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- remove highlight on escape (additionally to default <esc> behaviour)
map("n", "<esc>", "<cmd>noh<cr><esc>")

map("i", "<C-s>", "<cmd>wa!<CR>", { desc = "Write all buffers" })
map("n", "<C-s>", "<cmd>wa!<CR>", { desc = "Write all buffers" })
map("i", "<C-q>", "<cmd>qa<CR>", { desc = "Quit all buffers" })
map("n", "<C-q>", "<cmd>qa<CR>", { desc = "Quit all buffers" })
map("v", "d", '"_x"<esc>', { desc = "Delete without yanking" })
map("n", "dd", '"_dd', { desc = "Delete line without yanking" })
map("n", "D", '"_d$', { desc = "Delete to end of line without yanking" })
map("n", "Y", '"_y$', { desc = "Yank to end of line" })
map("n", "xx", "ddp", { desc = "Yank whole line and delete it" })
map("n", "Y", '"_y$"_d$', { desc = "Yank to end of line and delete to end of line" })

-- stop p from yanking selected text
vim.keymap.set("v", "p", '"_dP')

-- stop c from yanking
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_c$')
vim.keymap.set("v", "c", '"_c')
vim.keymap.set("v", "C", '"_c$')
vim.keymap.set("n", "c$", '"_c$')
vim.keymap.set("n", "c%", '"_c%')
vim.keymap.set("n", "c0", '"_c0')
vim.keymap.set("n", "c^", '"_c^')
vim.keymap.set("n", "c{", '"_c{')
vim.keymap.set("n", "c}", '"_c}')
vim.keymap.set("n", "cb", '"_cb')
vim.keymap.set("n", "ce", '"_ce')
vim.keymap.set("n", "cF", '"_cF')
vim.keymap.set("n", "cf", '"_cf')
vim.keymap.set("n", "cG", '"_cG')
vim.keymap.set("n", "ch", '"_ch')
vim.keymap.set("n", "cj", '"_cj')
vim.keymap.set("n", "ck", '"_ck')
vim.keymap.set("n", "cl", '"_cl')
vim.keymap.set("n", "cT", '"_cT')
vim.keymap.set("n", "ct", '"_ct')
vim.keymap.set("n", "cw", '"_cw')
vim.keymap.set("n", "c[", '"_c[')
vim.keymap.set("n", "c]", '"_c]')
vim.keymap.set("n", "ca", '"_ca')
vim.keymap.set("n", "cg", '"_cg')
vim.keymap.set("n", "ci", '"_ci')

-- explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- git
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
map("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gc", "<cmd>Git commit -v<CR>", { desc = "Git commit" })
map("n", "<leader>gb", "<cmd>Git branch<CR>", { desc = "Git branch" })
map("n", "<leader>gs", "<cmd>Git status<CR>", { desc = "Git status" })
map("n", "<leader>gd", "<cmd>Git diff<CR>", { desc = "Git diff" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })
map("n", "<leader>gS", "<cmd>Git stash<CR>", { desc = "Git stash" })
map("n", "<leader>gR", "<cmd>Git restore<CR>", { desc = "Git restore" })

-- telescope
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { desc = "Fuzzy search files" })
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy search in files" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "grep find in files" })
map(
    "n",
    "<leader>fb",
    "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({ sorting_strategy = 'ascending', prompt_position = 'top' })<cr>",
    { desc = "Fuzzy search current buffer" }
)
map("n", "<leader>fB", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy search buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Fuzzy search help tags" })
map("n", "<leader>p", "<cmd>Telescope neoclip<cr>", { desc = "Fuzzy search clipboard history" })
map("n", "<leader>z", "<cmd>Telescope zoxide list<cr>", { desc = "Fuzzy search zoxide history" })
map("n", "K", require("hover").hover, { desc = "Hover" })
-- map("n", "gK", require("hover").hover_select, { desc = "Hover select" })

-- harpoon
map("n", "<leader>hh", "<cmd>Telescope harpoon marks<cr>", { desc = "Fuzzy search Harpoon marks" })
map("n", "<leader>hc", "<cmd>lua require('harpoon.mark').clear_all()<cr>", { desc = "Clear all Harpoon marks" })
map("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Add file to Harpoon" })
map("n", "<leader>hj", '<cmd>lua require("harpoon.ui").nav_next()<cr>', { desc = "Navigate to next Harpoon mark" })
map("n", "<leader>hk", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', { desc = "Navigate to previous Harpoon mark" })
map("n", "<leader>h1", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', { desc = "Navigate to Harpoon mark 1" })
map("n", "<leader>h2", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', { desc = "Navigate to Harpoon mark 2" })
map("n", "<leader>h3", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', { desc = "Navigate to Harpoon mark 3" })
map("n", "<leader>h4", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', { desc = "Navigate to Harpoon mark 4" })
map("n", "<leader>h5", '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', { desc = "Navigate to Harpoon mark 5" })
map("n", "<leader>h6", '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', { desc = "Navigate to Harpoon mark 6" })
map("n", "<leader>h7", '<cmd>lua require("harpoon.ui").nav_file(7)<cr>', { desc = "Navigate to Harpoon mark 7" })
map("n", "<leader>h8", '<cmd>lua require("harpoon.ui").nav_file(8)<cr>', { desc = "Navigate to Harpoon mark 8" })
map("n", "<leader>h9", '<cmd>lua require("harpoon.ui").nav_file(9)<cr>', { desc = "Navigate to Harpoon mark 9" })

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>m", "<cmd>Glow<CR>", { desc = "Markdown preview" })

-- Prime
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
map("n", "J", "mzJ`z", { desc = "Move current line down" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- dap
local dap = require("dap")
map("n", "<f5>", dap.continue, { desc = "Continue" })
map("n", "<f10>", dap.step_over, { desc = "Step over" })
map("n", "<f11>", dap.step_into, { desc = "Step into" })
map("n", "<f12>", dap.step_out, { desc = "Step out" })
map("n", "<f9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
