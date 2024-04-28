local Git = {}

function Git.commit(title) vim.cmd(string.format('!git commit -m "%s"', title)) end

return Git
