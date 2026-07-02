-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Fix for Fn + Left/Right arrow keys being detected as <Find> and <Select>
vim.keymap.set({ "n", "i", "v", "c", "x", "o" }, "<Find>", "<Home>", { noremap = true, desc = "Home (Fn + Left)" })
vim.keymap.set({ "n", "i", "v", "c", "x", "o" }, "<Select>", "<End>", { noremap = true, desc = "End (Fn + Right)" })

