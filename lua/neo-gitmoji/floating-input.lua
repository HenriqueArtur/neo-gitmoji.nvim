local M = {}

local ns = vim.api.nvim_create_namespace("neo-gitmoji")
local counter_ns = vim.api.nvim_create_namespace("neo-gitmoji-counter")
local TITLE_MAX = 64

local history = {}
local MAX_HISTORY = 5

local function save_to_history(message)
  if message == "" then return end
  if history[1] == message then return end
  table.insert(history, 1, message)
  if #history > MAX_HISTORY then
    table.remove(history)
  end
end

local function confirm_action(callback, window, buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
  save_to_history(lines[1])
  vim.cmd("stopinsert")

  local function close()
    if vim.api.nvim_win_is_valid(window) then
      vim.api.nvim_win_close(window, true)
    end
  end

  local function show_error(err)
    if not vim.api.nvim_win_is_valid(window) then return end
    local first_line = err:match("([^\n]+)") or err
    vim.diagnostic.set(ns, buffer, {
      {
        lnum = 0,
        col = 0,
        message = first_line,
        severity = vim.diagnostic.severity.ERROR,
      },
    }, {})
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(window) then
        vim.cmd("startinsert")
      end
    end, 10)
  end

  callback(lines[1], close, show_error)
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

local function set_history_navigation(window, buffer)
  local history_index = 0
  local saved_text = ""

  local function set_line(text)
    vim.api.nvim_buf_set_lines(buffer, 0, 1, false, { text })
    vim.api.nvim_win_set_cursor(window, { 1, #text })
  end

  vim.keymap.set("i", "<Up>", function()
    if history_index == 0 then
      local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
      saved_text = lines[1]
    end
    if history_index < #history then
      history_index = history_index + 1
      set_line(history[history_index])
    end
  end, { buffer = buffer })

  vim.keymap.set("i", "<Down>", function()
    if history_index > 0 then
      history_index = history_index - 1
      if history_index == 0 then
        set_line(saved_text)
      else
        set_line(history[history_index])
      end
    end
  end, { buffer = buffer })
end

local function set_char_counter(buffer)
  local function update()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
    local count = vim.fn.strchars(lines[1] or "")
    local hl = count > TITLE_MAX and "WarningMsg" or "Comment"
    vim.api.nvim_buf_set_extmark(buffer, counter_ns, 0, 0, {
      id = 1,
      virt_text = { { string.format("[%d/%d]", count, TITLE_MAX), hl } },
      virt_text_pos = "eol",
    })
  end
  update()
  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = buffer,
    callback = update,
  })
end

---Define input commands
---@param window window
---@param buffer buffer
local function define_commands(window, buffer, on_confirmation_callback)
  set_keys_to_confirmation(window, buffer, on_confirmation_callback)
  set_keys_to_close_window(window, buffer)
  set_history_navigation(window, buffer)
  set_char_counter(buffer)
  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = buffer,
    callback = function() vim.diagnostic.reset(ns, buffer) end,
  })
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
  local buffer_options = define_buffer_options(title)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { the_initial_text })
  local window = vim.api.nvim_open_win(buffer, true, buffer_options)
  return window, buffer
end

---Set cursor after first initial position of text
---@param window window
---@param initial_text string
local function set_cursor_possition(window, initial_text)
  vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(initial_text) + 1 })
  vim.defer_fn(function() vim.cmd("startinsert") end, 10)
end

function M.create_floating_buffer(opt)
  local the_initial_text = ""
  local window, buffer = define_window_and_buffer(opt.title)
  set_cursor_possition(window, the_initial_text)
  define_commands(window, buffer, opt.on_confirmation_callback)
end

return M
