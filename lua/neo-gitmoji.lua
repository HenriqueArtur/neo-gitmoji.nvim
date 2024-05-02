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
      on_confirmation_callback = function(a_title) Git.commit(value.emoji .. " " .. a_title) end,
    })
  end)
end

return M
