local Git = {}

function Git.commit(title)
  local clean_title = title:gsub("`", "\\`")
  vim.cmd(string.format('!git commit -m "%s"', clean_title))
end

return Git
