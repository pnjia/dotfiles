local M = {}

local vault_root = vim.fn.expand("~/Documents/Second_Brain")

function M.goto_wiki_link()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
  local col = cursor[2]
  if not line then
    return false
  end

  local search_start = 1
  while true do
    local s, e, link = line:find("%[%[([^%[%]]+)%]%]", search_start)
    if not s then
      break
    end
    if col >= s - 1 and col <= e - 1 then
      local target = link:match("(.-)|") or link
      target = vim.trim(target)
      if target == "" then
        return false
      end

      local escaped = vim.fn.escape(target, "[]?*{}!\\")
      local files = vim.fn.glob(vault_root .. "/**/" .. escaped .. ".md", false, true)
      if #files > 0 then
        vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
      else
        local cur_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        local new_file = cur_dir .. "/" .. target .. ".md"
        vim.fn.mkdir(vim.fn.fnamemodify(new_file, ":h"), "p")
        vim.fn.writefile({ "# " .. target, "" }, new_file)
        vim.cmd("edit " .. vim.fn.fnameescape(new_file))
      end
      return true
    end
    search_start = e + 1
  end

  return false
end

return M
