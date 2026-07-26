-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Fix for Fn + Left/Right arrow keys being detected as <Find> and <Select>
vim.keymap.set({ "n", "i", "v", "c", "x", "o" }, "<Find>", "<Home>", { noremap = true, desc = "Home (Fn + Left)" })
vim.keymap.set({ "n", "i", "v", "c", "x", "o" }, "<Select>", "<End>", { noremap = true, desc = "End (Fn + Right)" })

-- === FIX: Visual d jangan timpa system clipboard ===
-- Clipboard=unnamedplus udah dihapus di options.lua
-- " register sekarang TERPISAH dari +
-- d di visual mode hanya ngaruh ke ", + tetap aman
-- Tapi y dan p harus langsung pakai + register biar work dengan clipboard luar

-- Yank ke system clipboard (biar bisa paste di luar nvim)
vim.keymap.set({ "n", "x" }, "y", '"+y', { noremap = true, desc = "Yank ke system clipboard" })
vim.keymap.set("n", "Y", '"+Y', { noremap = true, desc = "Yank line ke system clipboard" })

-- Paste dari system clipboard (biar paste teks dari luar nvim)
vim.keymap.set({ "n", "x" }, "p", '"+p', { noremap = true, desc = "Paste dari system clipboard" })
vim.keymap.set({ "n", "x" }, "P", '"+P', { noremap = true, desc = "Paste sebelum cursor dari system clipboard" })
-- Visual mode: paste replace tanpa simpan teks yg diganti ke register
vim.keymap.set("x", "p", '"_d"+P', { noremap = true, desc = "Paste replace dari system clipboard" })

