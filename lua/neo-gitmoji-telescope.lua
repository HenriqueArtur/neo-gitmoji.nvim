vim.api.nvim_create_user_command("NeoGitmoji", function()
  local package_name = "lua.utils.gitmoji-picker"
  package.loaded[package_name] = nil
  require(package_name).open()
end, {})
