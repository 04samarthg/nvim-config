-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- execute js file with nodejs
keymap.set("n", "<leader>js", ":w !node <ENTER>", { desc = "Save and Execute js file using node" })

-- Compile and run C++ code
keymap.set('n', '<C-b>', ':w | !time g++ --std=c++20 -o main % && ./main<CR>')
keymap.set('n', '<C-l>', ':w | !time g++ --std=c++20 --debug -o main % && ./main<CR>')

-- Select all text in insert mode with Ctrl+a
keymap.set("i", "<C-a>", "<Esc>ggVG<CR>a", { desc = "Select all text" })
keymap.set("n", "<C-a>", "ggVG<CR>", { desc = "Select all text" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("n", "<C-d>", "<C-d>zz") -- keeps cursor in middle when using CTRL-d
keymap.set("n", "<C-u>", "<C-u>zz") -- keeps cursor in middle when using CTRL-u
vim.keymap.set("n", "<leader>q", ":wqa<CR>", { silent = true, desc = "Save and [Q]uit Neovim" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "[W]rite" })

-- Re-select blocks after indenting in visual/select mode
keymap.set('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
keymap.set('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

-- Use tab for indenting in visual/select mode
keymap.set('v', '<Tab>', '>gv|', { desc = 'Indent Left' })
keymap.set('v', '<S-Tab>', '<gv', { desc = 'Indent Right' })

keymap.set('n', '<leader>cf', "<cmd>CFStart<CR>", { desc = "Start the CF plugin"})
keymap.set('n', '<leader>cn', "<cmd>CFShow<CR>", {desc = "Select the problem to parse"})

if vim.g.neovide then
    keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- Disable default mappings
-- vim.g.copilot_no_tab_map = true
--
-- -- Custom mappings
-- vim.api.nvim_set_keymap("i", "<C-G>", 'copilot#Accept("\\<CR>")', { silent = true, expr = true, script = true })
-- vim.api.nvim_set_keymap("i", "<C-X>", 'copilot#Dismiss("<CR>")', { silent = true, expr = true, script = true })
-- vim.api.nvim_set_keymap("i", "<C-N>", 'copilot#Next()', { silent = true, expr = true, script = true })
-- vim.api.nvim_set_keymap("i", "<C-P>", 'copilot#Previous()', { silent = true, expr = true, script = true })
-- vim.api.nvim_set_keymap("i", "<C-X>", 'copilot#Dismiss()', { silent = true, expr = true, script = true })

-- DAP
vim.api.nvim_set_keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { noremap = true, silent = true })
