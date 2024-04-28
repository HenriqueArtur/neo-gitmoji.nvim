local picker = require("lua.utils.gitmoji-picker").open_gitmoji_picker
local floating_input = require("lua.utils.floating-input")

local M = {}

function M.setup_neo_gitmoji()
  picker(function(value)
    floating_input.create_floating_buffer({
      title = "Enter the commit title: [gitmoji " .. value.emoji .. "]",
      on_confirmation_callback = function(a_title)
        print(value.emoji .. " " .. a_title)
      end,
    })
  end)
end

vim.api.nvim_create_user_command("NeoGitmoji", function() M.setup_neo_gitmoji() end, {})

return M
