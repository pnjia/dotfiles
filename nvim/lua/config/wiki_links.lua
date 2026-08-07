local M = {}

local vault_root = vim.fn.expand("~/Documents/Second_Brain")

local function url_decode(s)
  return s:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
end

local function open_path(path)
  path = url_decode(path)
  path = vim.trim(path)
  if path == "" then
    return false
  end

  local candidates = {}
  if vim.startswith(path, "/") then
    table.insert(candidates, path)
    table.insert(candidates, vault_root .. path)
  else
    table.insert(candidates, path)
    table.insert(candidates, vault_root .. "/" .. path)
  end
  table.insert(candidates, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h") .. "/" .. path)

  for _, c in ipairs(candidates) do
    local files = vim.fn.glob(c, false, true)
    if #files > 0 and vim.fn.filereadable(files[1]) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
      return true
    end
  end
  return false
end

local function goto_markdown_link()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
  local col = cursor[2]
  if not line then
    return false
  end

  local search_start = 1
  while true do
    local s, e, _, url = line:find("%[(.-)%]%((.-)%)", search_start)
    if not s then
      break
    end
    if col >= s - 1 and col <= e - 1 then
      return open_path(url)
    end
    search_start = e + 1
  end

  return false
end

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

function M.goto_link()
  if goto_markdown_link() then
    return true
  end
  return M.goto_wiki_link()
end

return M
