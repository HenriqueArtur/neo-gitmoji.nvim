local picker = require("neo-gitmoji.gitmoji-picker").open_gitmoji_picker
local floating_input = require("neo-gitmoji.floating-input")

local M = {}

function M.setup()
  picker(function(value)
    floating_input.create_floating_buffer({
      title = "Enter the commit title: [gitmoji " .. value.emoji .. "]",
      on_confirmation_callback = function(a_title) print(value.emoji .. " " .. a_title) end,
    })
  end)
end

return M
