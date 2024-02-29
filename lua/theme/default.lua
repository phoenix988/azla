-- Import function to check if a file exist
local fileExist = require("lua.fileExist").fileExists

local loadConfig = require("lua.loadConfig").load_config_theme

-- Import Variables
local file = require("lua.config.init")

-- Import some widgets we need
local array = require("lua.widgets.setting")

-- Sets custom config path
local customConfig = file.config.custom

local M = {}

-- Import font
M.font = require("lua.theme.font")
M.setting = require("lua.theme.setting")

-- Default values are set here
local label_welcome = "#84a0c6"
local label_lang = "#89b8c2"
local label_word = "#89b8c2"
local label_question = "#89b8c2"
local label_correct = "#b4be82"
local label_incorrect = "#e27878"
local label_fg = "#d8dee9"

-- Variable to always load default values so you can easily restore
-- Sets default theme values to load so you can reset
M.theme_default = {
	label_welcome = label_welcome,
	label_lang = label_lang,
	label_word = label_word,
	label_question = label_question,
	label_correct = label_correct,
	label_incorrect = label_incorrect,
	label_fg = label_fg,
}

-- Load theme
function M.load()
	-- check if custom file exist
	if fileExist(customConfig) then
		themeCustom = loadConfig(customConfig)
	end

	M.scheme = color_scheme

	if color_scheme == "Iceberg" or color_scheme == "iceberg" then
		local theme = require("lua.theme.colorschemes.iceberg")

		return theme
	elseif color_scheme == "Dracula" or color_scheme == "dracula" then
		local theme = require("lua.theme.colorschemes.dracula")

		return theme
	elseif color_scheme == "Nord" or color_scheme == "nord" then
		local theme = require("lua.theme.colorschemes.nord")

		return theme
	elseif color_scheme == "Tokyo-night" or color_scheme == "tokyo-night" then
		local theme = require("lua.theme.colorschemes.tokyo-night")

		return theme
	elseif color_scheme == "Custom" or color_scheme == "custom" or not color_scheme then
		if theme ~= nil then
			themeCompare = theme
		end

		-- Sets default theme values
		-- will only be present if the config file is empty
		local theme = {
			label_welcome = label_welcome,
			label_lang = label_lang,
			label_word = label_word,
			label_question = label_question,
			label_correct = label_correct,
			label_incorrect = label_incorrect,
			label_fg = label_fg,
		}

		-- Overwrites config if you have a custom one
		if themeCompare ~= nil then
			for key, value in pairs(theme) do
				if themeCompare[key] ~= nil then
					theme[key] = themeCompare[key]
				end
			end
		end

		return theme
    else
		local theme = require("lua.theme.colorschemes.tokyo-night")

		return theme
    end

end

-- Function to set the colorscheme
function M.color_scheme(treeView, write, update)
	local theme = M.load()
	-- Get active value of the treeview
	local selection = treeView.tree:get_selection()
	local model, iter = selection:get_selected()
	if model and iter then
		local value = model:get_value(iter, 0) -- Assuming the value is in column 0
		stringValue = value:get_string() -- Convert value to string
	end

	label.current_color_scheme:set_text("Current theme is: " .. stringValue)
	label.current_color_scheme:set_markup(
		"<span size='"
			.. font.fg_size
			.. "' foreground='"
			.. theme.label_word
			.. "'>"
			.. label.current_color_scheme.label
			.. "</span>"
	)

	local status = write.write.config.color_scheme('color_scheme = "' .. stringValue .. '"\n', customConfig)

	local theme = M.load()

	update.live(theme)

	for key, value in pairs(theme) do
		local value = theme[key]
		local match = string.match(value, "#")

		if match then
			local defaultColor = array.hashToRGBA(value)

			array.theme_labels[key]:set_rgba(defaultColor)
		end
	end
end

-- Returns the module
return M
