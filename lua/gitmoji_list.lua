local GITMOJI_LIST = require("lua.emoji_list")

local GITMOJI_LIST_STRINGS = {}
for _, emoji in ipairs(GITMOJI_LIST) do
	table.insert(GITMOJI_LIST_STRINGS, emoji.emoji .. " - " .. emoji.description)
end

return GITMOJI_LIST_STRINGS
