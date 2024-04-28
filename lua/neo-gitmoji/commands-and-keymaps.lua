local start_neo_gitmoji = require("lua.neo-gitmoji").setup

local M = {}

function M.set_commands()
  vim.api.nvim_create_user_command("NeoGitmoji", function() M.setup() end, {})
end

return M
