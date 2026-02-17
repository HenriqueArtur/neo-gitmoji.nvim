local Git = {}

function format_title(title)
  return title:gsub("`", "\\`")
end

function Git.commit(title, on_success, on_failure)
  local output = {}

  vim.fn.jobstart({ "git", "commit", "-m", title }, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(output, line)
        end
      end
    end,
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(output, line)
        end
      end
    end,
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code == 0 then
        on_success()
      else
        on_failure(table.concat(output, "\n"))
      end
    end),
  })
end

return Git
