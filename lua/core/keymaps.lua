vim.g.mapleader = " "

local km = vim.keymap

km.set("i", "<C-w>", "<C-\\><C-o>:wa<CR>")
km.set("n", "<C-w>", ":wa<CR>")
km.set("i", "<C-q>", "<C-o>:qa<CR>")
km.set("n", "<C-q>", ":qa<CR>")
km.set("n", "x", '"_x"')
km.set("v", "d", '"_x"<esc>')

-- explorer
km.set("n", "<leader>e", ":NvimTreeToggle<CR>")
km.set("n", "<leader>o", ":NvimTreeFocus<CR>")

-- telescope
km.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
km.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")
km.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")
km.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
km.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- increment/decrement numbers
km.set("n", "<leader>+", "<C-a>")
km.set("n", "<leader>-", "<C-x>")

-- split window
km.set("n", "<leader>sv", "<C-w>v")
km.set("n", "<leader>sh", "<C-w>s")

-- Prime
km.set("v", "J", ":m '>+1<CR>gv=gv")
km.set("v", "K", ":m '<-2<CR>gv=gv")
km.set("n", "J", "mzJ`z")
km.set("n", "<C-d>", "<C-d>zz")
km.set("n", "<C-u>", "<C-u>zz")
km.set("x", "<leader>p", '"_dP')

--vim.o.copilot_no_tab = true
--vim.cmd [[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]]
