vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

map("i", "<C-w>", "<C-\\><C-o>:wa!<CR>", { desc = "Write all buffers" })
map("n", "<C-w>", ":wa!<CR>", { desc = "Write all buffers" })
map("i", "<C-q>", "<C-o>:qa<CR>", { desc = "Quit all buffers" })
map("n", "<C-q>", ":qa<CR>", { desc = "Quit all buffers" })
map("v", "d", '"_x"<esc>', { desc = "Delete without yanking" })

-- explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>o", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files" })
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy search in files" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "grep find in files" })
map("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy search current buffer" })
map("n", "<leader>fB", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy search buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Fuzzy search help tags" })
map("n", "<leader>p", "<cmd>Telescope neoclip<cr>", { desc = "Fuzzy search clipboard history" })
map("n", "<leader>z", "<cmd>Telescope zoxide list<cr>", { desc = "Fuzzy search zoxide history" })

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

-- split window
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- Prime
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
map("n", "J", "mzJ`z", { desc = "Move current line down" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

--vim.o.copilot_no_tab = true
--vim.cmd [[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
