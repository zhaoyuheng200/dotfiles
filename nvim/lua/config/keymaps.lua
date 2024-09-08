-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- remove default "Move Up/Down" key binding.
-- These are updated to use uppercase in mini.move.lua
vim.keymap.del("n", "<M-k>")
vim.keymap.del("n", "<M-j>")

vim.keymap.del("i", "<M-k>")
vim.keymap.del("i", "<M-j>")

vim.keymap.del("v", "<M-k>")
vim.keymap.del("v", "<M-j>")

-- use Tab for <C-y> in autocompletion
-- TODO

-- vim.keymap.set("n", "<M-K>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- vim.keymap.set("n", "<M-J>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- vim.keymap.set("n", "<M-K>", "<cmd>lua minimove.move_line('up')", { desc = "Move Up" })
-- vim.keymap.set("n", "<M-J>", "<cmd>lua minimove.move_line('down')", { desc = "Move Down" })
-- vim.keymap.set("i", "<M-K>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- vim.keymap.set("i", "<M-J>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- vim.keymap.set("v", "<M-K>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- vim.keymap.set("v", "<M-J>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
