-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable all diagnostics for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.schedule(function()
      vim.diagnostic.enable(false)
    end)
  end,
})

-- Fallback [[wiki-link]] navigation when no LSP is attached
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local wiki = require("config.wiki_links")
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "gd", function()
      if not wiki.goto_wiki_link() then
        vim.lsp.buf.definition()
      end
    end, { buffer = buf, desc = "Wiki-link / LSP definition" })
  end,
})


