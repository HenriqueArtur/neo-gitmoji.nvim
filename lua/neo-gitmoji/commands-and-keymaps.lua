local start_neo_gitmoji = require("lua.neo-gitmoji").setup

local M = {}

function M.set_commands()
  vim.api.nvim_create_user_command("NeoGitmoji", function() M.setup() end, {})
end

function M.set_keymaps()
  vim.keymap.set("n", "<leader>gm", function() start_neo_gitmoji() end, {
    desc = "Gitmoji",
  })
end

return M
