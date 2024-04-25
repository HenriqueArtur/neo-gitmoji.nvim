local M = {}

local function define_buffer_options(title)
	local the_title = title or "Input:"
	local height = 1
	local width = math.floor(vim.o.columns * 0.8)
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

---Define input commands
---@param window window
---@param buffer buffer
local function define_commands(window, buffer)
	-- Enter to confirm
	vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
		local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
		--
		print(lines[1])
		--
		vim.api.nvim_win_close(window, true)
		vim.cmd("stopinsert")
	end, { buffer = buffer })
	-- Esc or q to close
	vim.keymap.set("n", "<esc>", function()
		vim.api.nvim_win_close(window, true)
	end, { buffer = buffer })
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(window, true)
	end, { buffer = buffer })
end

---Set cursor after first initial position of text
---@param window window
---@param initial_text string
local function set_cursor_possition(window, initial_text)
	vim.cmd("startinsert")
	vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(initial_text) + 1 })
end

function M.create_floating_buffer(title, initial_text)
	local the_initial_text = initial_text or ""
	local buffer_options = define_buffer_options(title)
	local buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { the_initial_text })
	local window = vim.api.nvim_open_win(buffer, true, buffer_options)
	set_cursor_possition(window, the_initial_text)
	define_commands(window, buffer)
end

vim.api.nvim_create_user_command("Floating", function()
	package.loaded.floatingInput = nil
	require("lua.floating-input").create_floating_buffer("Title:")
end, {})

return M
