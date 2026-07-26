-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guicursor = {
  "n-v-c:block-blinkwait700-blinkon400-blinkoff250",
  "i-ci:ver25-blinkwait700-blinkon400-blinkoff250",
  "r-cr:hor20-blinkwait700-blinkon400-blinkoff250",
  "o:hor50-blinkwait700-blinkon400-blinkoff250",
}

vim.opt.number = true
vim.opt.relativenumber = false

-- Hapus clipboard=unnamedplus dari LazyVim
-- unnamedplus sinkronkan " register dengan system clipboard
-- Akibat: visual d → cut ke " → timpa clipboard luar
-- Fix: pakai mapping y/p langsung ke + register
vim.opt.clipboard = ""
