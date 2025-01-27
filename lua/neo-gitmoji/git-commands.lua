local Git = {}

function format_title(title)
  return title:gsub("`", "\\`")
end

function Git.commit(title)
  vim.cmd(string.format('!git commit -m "%s"', format_title(title)))
end

return Git
