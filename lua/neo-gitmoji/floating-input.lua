local M = {}

local function confirm_action(callback, window, buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
  callback(lines[1])
  vim.api.nvim_win_close(window, true)
  vim.cmd("stopinsert")
end

local function set_keys_to_confirmation(window, buffer, callback)
  vim.keymap.set(
    { "n", "i", "v" },
    "<cr>",
    function() confirm_action(callback, window, buffer) end,
    { buffer = buffer }
  )
end

local function close_window(window) vim.api.nvim_win_close(window, true) end

local function set_keys_to_close_window(window, buffer)
  vim.keymap.set("n", "<esc>", function() close_window(window) end, { buffer = buffer })
  vim.keymap.set("n", "q", function() close_window(window) end, { buffer = buffer })
end

---Define input commands
---@param window window
---@param buffer buffer
local function define_commands(window, buffer, on_confirmation_callback)
  set_keys_to_confirmation(window, buffer, on_confirmation_callback)
  set_keys_to_close_window(window, buffer)
end

local function define_buffer_options(title)
  local the_title = title or "Input:"
  local height = 1
  local width = math.floor(vim.o.columns * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return {
    title = the_title,
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    focusable = true,
    border = "rounded",
  }
end

local function define_window_and_buffer(title, the_initial_text)
  local SECOND_TITLE_SIGN = "SecondTitleSign"

  local buffer_options = define_buffer_options(title)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { the_initial_text })

  vim.fn.sign_define(SECOND_TITLE_SIGN, { text = "Second Title", texthl = "Title" })
  vim.fn.sign_place(0, "line", SECOND_TITLE_SIGN, buffer, { lnum = 0 })

  local window = vim.api.nvim_open_win(buffer, true, buffer_options)
  return window, buffer
end

---Set cursor after first initial position of text
---@param window window
---@param initial_text string
local function set_cursor_possition(window, initial_text)
  vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(initial_text) + 1 })
  vim.cmd("startinsert")
end

function M.create_floating_buffer(opt)
  local the_initial_text = ""
  local window, buffer = define_window_and_buffer(opt.title)
  set_cursor_possition(window, the_initial_text)
  define_commands(window, buffer, opt.on_confirmation_callback)
end

return M
