vim.o.ttimeoutlen = 0

-- Enable automatic reading of externally changed files
vim.opt.autoread = true

-- Set up autocommands to check for changes on various events
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("AutoReload", { clear = true }),
  callback = function()
    -- Check if the current mode is not 'command-line' before checking time
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Optional: Add a notification after a file has been reloaded from disk
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  group = vim.api.nvim_create_augroup("FileChangeNotify", { clear = true }),
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
})

require("config.lazy")
