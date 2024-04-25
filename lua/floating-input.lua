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

--- Define input commands
-- @param window to attach commands
-- @param buffer to attach commands
local function define_commands(window, buffer)
	-- Esc or q to close
	vim.keymap.set("n", "<esc>", function()
		vim.api.nvim_win_close(window, true)
	end, { buffer = buffer })
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(window, true)
	end, { buffer = buffer })
end

function M.create_floating_buffer(title)
	local buffer_options = define_buffer_options(title)
	-- Create a new scratch buffer
	local buffer = vim.api.nvim_create_buf(false, true)
	-- Open buffer in a floating window
	local window = vim.api.nvim_open_win(buffer, true, buffer_options)
	define_commands(window, buffer)
end

vim.api.nvim_create_user_command("Floating", function()
	package.loaded.floatingInput = nil
	require("lua.floating-input").create_floating_buffer("Title:")
end, {})

return M
