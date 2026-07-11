-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Template command untuk Second Brain
vim.api.nvim_create_user_command("Template", function(ctx)
  local templates = {
    konsep = "099_System/Templates/Konsep.md",
    catatan = "099_System/Templates/Catatan.md",
    inbox = "099_System/Templates/Inbox.md",
  }
  local tpl = templates[ctx.args]
  if not tpl then
    vim.notify("Template tidak ditemukan. Pilih: konsep, catatan, inbox", vim.log.levels.ERROR)
    return
  end
  local vault = vim.fn.expand("~/Documents/Second_Brain")
  local lines = vim.fn.readfile(vault .. "/" .. tpl)
  local title = vim.fn.expand("%:t:r")
  lines = vim.iter(lines):map(function(line)
    line = line:gsub("{{title}}", title)
    line = line:gsub('"{ date }":', os.date("%Y-%m-%d"))
    return line
  end):totable()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, { nargs = 1, desc = "Apply template: konsep, catatan, inbox" })
