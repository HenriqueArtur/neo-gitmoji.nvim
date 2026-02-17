local picker = require("neo-gitmoji.gitmoji-picker").open_gitmoji_picker
local Git = require("neo-gitmoji.git-commands")
local floating_input = require("neo-gitmoji.floating-input")

local M = {}

function M.setup()
  local config = require("neo-gitmoji.commands-and-keymaps")
  config.set_commands()
  config.set_keymaps()
end

function M.open_floating()
  picker(function(value)
    floating_input.create_floating_buffer({
      title = "Enter the commit title: [gitmoji " .. value.emoji .. "]",
      on_confirmation_callback = function(a_title, close, show_error)
        local full_title = value.emoji .. " " .. a_title
        Git.commit(
          full_title,
          function()
            vim.notify("Committed: " .. full_title, vim.log.levels.INFO)
            close()
          end,
          function(err)
            vim.notify(err, vim.log.levels.ERROR)
            show_error(err)
          end
        )
      end,
    })
  end)
end

return M
