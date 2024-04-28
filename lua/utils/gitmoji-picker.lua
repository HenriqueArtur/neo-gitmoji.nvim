local M = {}

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local GITMOJI_LIST = require("lua.emoji-list")

local default_opts = {
  layout_strategy = "vertical",
  layout_config = {
    height = 10,
    width = 0.4,
    prompt_position = "top",
  },
}

local results_title = "| List |"
local prompt_title = "| Chose a gitmoji |"

local function get_gitmoji_list() return GITMOJI_LIST end

---Format list to telescope
---@param entry table A gitmoji item
---@return table
local function entry_maker(entry)
  return {
    value = entry,
    display = entry.emoji .. " - " .. entry.description,
    ordinal = entry.description,
  }
end

local finder = finders.new_dynamic({
  fn = get_gitmoji_list,
  entry_maker = entry_maker,
})

local attach_mappings = function(prompt_bufnr, callback)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    callback(selection.value)
  end)
end

function M.open_gitmoji_picker(callback, opts)
  opts = opts or default_opts
  pickers
    .new(opts, {
      prompt_title = prompt_title,
      results_title = results_title,
      finder = finder,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        attach_mappings(prompt_bufnr, callback)
        return true
      end,
    })
    :find()
end

return M
