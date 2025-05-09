local map = vim.keymap.set

-- better up and down
map({ "x", "n" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "x", "n" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- resize window with <CTRL> hjkl
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase win height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease win height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Descrease win width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase win width" })

-- move lines
-- normal mode
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
-- insert mode move line
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
-- visual mode move line
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Keybinds to move the buffer page up and down
map("n", "<C-d>", "<C-d>zz", { desc = "Move page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Move page up" })
