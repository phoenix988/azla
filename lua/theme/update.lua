-- Update function to update the theme of the app
-- mainly for live update and restore default value

local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local label = require("lua.widgets.label")
local array = require("lua.widgets.setting")
local theme = require("lua.theme.default")
local setting = require("lua.theme.setting")
local var = require("lua.config.init")
local write = require("lua.config.init")
local GLib = require("lgi").GLib
local treeView = require("lua.widgets.button.treeView")
local style = require("lua.widgets.setting")

-- Imports string functions
local list = require("lua.terminal.listFiles")

local confPath = var.config.custom
local confDir = var.config.dir

local M = {}


-- function to update word list menu when updating theme
function M.update_word_list()
	-- Update the word list menu settings
	local menu = require("lua.widgets.menu.init")
    local theme = require("lua.theme.default").load()
    local font = require("lua.theme.default").font.load()

	-- Function to remove childs from grid or any widget
	local function clear_grid(grid)
		local child = grid:get_last_child()
		while child do
			grid:remove(child)
			child = grid:get_last_child()
		end
	end

	for key, value in pairs(menu.grid_items) do
		clear_grid(menu.grid_items[key])
	end

	local newMenu = {}
	newMenu.wordList_items = {}
	newMenu.grid_items = {}
	newMenu.entry_items = {}
	newMenu.import_items = {}
	newMenu.new_list = {}
	newMenu.label_list = {}

	local directoryPath = var.wordDir
	local luaFiles = list.dir(directoryPath)

	for i, item_label in ipairs(luaFiles) do
		local wordList = list.modify(item_label)

		newMenu.wordList_items[i] = require(var.wordMod .. "." .. wordList)

		-- Clear box
		clear_grid(menu.box[i])

		-- Sets the first entry boxes to add a new word
		local entry_az = Gtk.Entry({ margin_top = 50, placeholder_text = "Azerbajani Word" })
		local entry_eng = Gtk.Entry({ margin_top = 50, placeholder_text = "English Word" })

		-- Create submit and add button for the grid
		local submit = Gtk.Button({ label = "Submit" })
		local addAnother = Gtk.Button({ margin_top = 50, label = "Add" })

		-- Make all dirs to lowercase
		local lower = wordList:lower()

		-- Create label az and append it to the box
		local label_az = Gtk.Label({ label = "Azerbajani - English" })

		-- Create spacer widget
		local spacer = Gtk.Label()
		-- Set theme on title label
		label_az:set_markup(
			"<span size='"
				.. font.welcome_size
				.. "' foreground='"
				.. theme.label_welcome
				.. "'>"
				.. label_az.label
				.. "</span>"
		)

		-- Append to the box widget when updating color
		menu.box[i]:append(label_az)
		menu.box[i]:append(spacer)
		menu.box[i]:append(menu.grid_main[i])

		-- Make sure you dont get errors
		local success, result = pcall(function()
			NewSubDir = list.dir(directoryPath .. "/" .. lower)
		end)

		-- If pcall succedd this will run
		if success then
			newMenu.import_items[wordList] = {}
			newMenu.new_list[wordList] = {}
			for k = 1, #NewSubDir do
				local last = list.modify(NewSubDir[k])
				local allWords = lower .. "/" .. last
				local import = require(var.wordMod .. "." .. allWords)
				table.insert(newMenu.import_items[wordList], import)

				for key, value in ipairs(import) do
					for j = 1, #value do
						table.insert(newMenu.new_list[wordList], value[j])
					end
				end
			end
		end

		-- append the button grid to the box
		--menu.box[i]:append(menu.grid[i])

		-- Function to check for even numbers
		local function isEven(number)
			return number % 2 == 0
		end

		if type(newMenu.import_items[wordList]) == "table" then
			-- Keep track of even and uneven
			local countTime = 0
			-- Create final WordTable to add all words from the diffrent lists
			-- To one single table
			NewWordTable = {}
			for key, value in ipairs(newMenu.new_list[wordList]) do
				if not isEven(key) then
					countTime = countTime + 1
					NewWordTable[countTime] = { newMenu.new_list[wordList][key], newMenu.new_list[wordList][key + 1] }
				end
			end

			-- Finally we create the diffrent labels for the words in the wordlist
			for j = 1, #NewWordTable do
				newMenu.label_list[wordList] = {}
				local english = list.to_upper(NewWordTable[j][2])
				local aze = list.to_upper(NewWordTable[j][1])
				local form = aze .. " : " .. english
				local row = math.floor((j - 1) / 3)
				local col = (j - 1) % 3
				local label = Gtk.Label({ label = form })
				-- Set label theme
				label:set_markup(
					"<span size='"
						.. font.word_list_size
						.. "' foreground='"
						.. theme.label_fg
						.. "'>"
						.. label.label
						.. "</span>"
				)

				menu.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)

				menu.label_list[wordList][j] = label
			end
		else
			for j = 1, #newMenu.wordList_items[i] do
				newMenu.label_list[wordList] = {}
				local english = list.to_upper(newMenu.wordList_items[i][j][2])
				local aze = list.to_upper(newMenu.wordList_items[i][j][1])
				local form = aze .. " : " .. english
				if wordList == "Phrases" then
					row = math.floor((j - 1) / 1)
					col = (j - 1) % 1
				else
					row = math.floor((j - 1) / 3)
					col = (j - 1) % 3
				end
				local label = Gtk.Label({ label = form })

				-- Set label theme
				label:set_markup(
					"<span size='"
						.. font.word_list_size
						.. "' foreground='"
						.. theme.label_fg
						.. "'>"
						.. label.label
						.. "</span>"
				)

				newMenu.label_list[wordList][j] = label

				menu.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)
			end
		end
	end
end

-- Function to update your theme while the app is running
function M.live(theme)
	local themeModule = require("lua.theme.default")
	local font = themeModule.font.load()
	local setting = require("lua.theme.setting").load()
	local button = require("lua.widgets.button")
	style.color = themeModule.load()

	-- Update widget properties based on the new settings
	label.welcome:set_text(label.text.welcome)
	label.welcome:set_markup(
		"<span size='"
			.. font.welcome_size
			.. "' foreground='"
			.. theme.label_welcome
			.. "'>"
			.. label.welcome.label
			.. "</span>"
	)

	-- Update other widgets as needed

	--- Updating labels
	label.theme:set_text("Settings")
	label.theme:set_markup(
		"<span size='"
			.. font.welcome_size
			.. "' foreground='"
			.. theme.label_fg
			.. "'>"
			.. label.theme.label
			.. "</span>"
	)

	label.theme_apply:set_text("Applied new settings. Please restart the app")
	label.theme_apply:set_markup(
		"<span size='"
			.. font.fg_size
			.. "' foreground='"
			.. theme.label_correct
			.. "'>"
			.. label.theme_apply.label
			.. "</span>"
	)

	for key, value in pairs(label.theme_restore) do
		label.theme_restore[key]:set_text("Restored to default settings")
		label.theme_restore[key]:set_markup(
			"<span size='"
				.. font.fg_size
				.. "' foreground='"
				.. theme.label_fg
				.. "'>"
				.. label.theme_restore[key].label
				.. "</span>"
		)
	end

	label.word_list:set_text("Choose your wordlist")
	label.word_list:set_markup(
		"<span size='"
			.. font.word_size
			.. "' foreground='"
			.. theme.label_word
			.. "'>"
			.. label.word_list.label
			.. "</span>"
	)

	label.language:set_text("Choose Language you want to write answers in:")
	label.language:set_markup(
		"<span size='"
			.. font.lang_size
			.. "' foreground='"
			.. theme.label_lang
			.. "'>"
			.. label.language.label
			.. "</span>"
	)

	label.word_count:set_text("Choose word amount")
	label.word_count:set_markup(
		"<span size='"
			.. font.word_size
			.. "' foreground='"
			.. theme.label_word
			.. "'>"
			.. label.word_count.label
			.. "</span>"
	)

	-- Updates theme labels
	for key, value in pairs(theme) do
		-- Removes the seperator and add a space instead
		local labelValue = string.gsub(key, "_", " ")
		local labelValue = list.to_upper(labelValue)

		-- Updates the labels and values
		array.theme_labels_setting[key]:set_text(labelValue)
		array.theme_labels_setting[key]:set_markup(
			"<span foreground='"
				.. theme.label_fg
				.. "'size='"
				.. font.fg_size
				.. "'>"
				.. array.theme_labels_setting[key].label
				.. "</span>"
		)
	end

	-- Updates setting labels
	for key, value in pairs(setting) do
		-- Removes the seperator and add a space instead
		local labelValue = string.gsub(key, "_", " ")
		local labelValue = string.gsub(labelValue, "default ", "")
		local labelValue = list.to_upper(labelValue)

		-- Updates the labels and values
		array.theme_labels_setting[key]:set_text(labelValue)
		array.theme_labels_setting[key]:set_markup(
			"<span foreground='"
				.. theme.label_fg
				.. "'size='"
				.. font.fg_size
				.. "'>"
				.. array.theme_labels_setting[key].label
				.. "</span>"
		)
		array.setting_labels[key]:set_text(value)
	end

	for key, value in pairs(font) do
		-- Removes the seperator and add a space instead
		local labelValue = string.gsub(key, "_", " ")
		local labelValue = list.to_upper(labelValue)

		-- Updates the labels and values
		array.theme_labels_setting[key]:set_text(labelValue)
		array.theme_labels_setting[key]:set_markup(
			"<span foreground='"
				.. theme.label_fg
				.. "'size='"
				.. font.fg_size
				.. "'>"
				.. array.theme_labels_setting[key].label
				.. "</span>"
		)
		local value = value / 1000
		local value = tostring(value):gsub("%.0+$", "")
		array.theme_labels[key]:set_value(value)
	end

	-- Update treeview widget
	treeView.tree = array.set_theme(
		treeView.tree,
		{ { size = font.fg_size / 1000, color = theme.label_word, border_color = theme.label_fg } }
	)

	-- Get active value of the treeview
	local selection = treeView.tree:get_selection()
	local model, iter = selection:get_selected()
	if model and iter then
		local value = model:get_value(iter, 0) -- Assuming the value is in column 0
		stringValue = value:get_string() -- Convert value to string
	end

	-- Update color scheme label
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

	-- Update button properties when updating theme
	-- Creating button update table
	button.update = {
		setting = button.setting,
		setting_back = button.setting_back,
		setting_submit = button.setting_submit,
		setting_wordlist = button.setting_wordlist,
		exit_alt = button.exit_alt,
		exit = button.exit,
		start = button.start,
		exam_mode = button.exam_mode,
		restore_mode = button.restore_mode,
	}

	-- Update colors of all buttoons that I stored in button update table
	for key, _ in pairs(button.update) do
		button.update[key] = style.set_theme(button.update[key], {
			{
				color = style.color.label_welcome,
				border_color = style.color.label_welcome,
				size = font.fg_size / 1000,
			},
		})
	end

	-- Update all restore buttons
	for key, _ in pairs(array.restore_button) do
		array.restore_button[key] = style.set_theme(
			array.restore_button[key],
			{ { color = style.color.label_fg, border_color = style.color.label_fg, size = font.welcome_size / 1000 } }
		)
	end

	-- Runs the function to update wordlist menu
	M.update_word_list()
end

-- Restore default settings
function M.restore(arg)
	local setting_default = {
		default_width = 1200,
		default_height = 1000,
		image = "/opt/azla/images/flag.jpg",
	}

	if arg == "theme" then -- Restore to default theme
		local theme_default = theme.theme_default
		local font = theme.font.load()
		local theme = theme.load()
		local setting = require("lua.theme.setting")
		local setting = setting.load()

		write.write.config.theme(confPath, theme_default, theme, setting, font)

		label.theme_restore.theme:set_visible(true)

		local timer_id
		timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
			label.theme_restore.theme:set_visible(false)
			return false -- Return false to stop the timer after executing once
		end)

		for key, value in pairs(theme_default) do
			local value = theme_default[key]
			local match = string.match(value, "#")

			if match then
				local defaultColor = array.hashToRGBA(value)

				array.theme_labels[key]:set_rgba(defaultColor)
			end
		end

		M.live(theme_default)
	elseif arg == "setting" then -- restore standard settings
		local setting = require("lua.theme.setting")
		local font = theme.font.load()
		local theme = theme.load()
		local setting = setting.load()

		write.write.config.setting(confPath, setting_default, theme, font)

		label.theme_restore.setting:set_visible(true)

		local timer_id
		timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
			label.theme_restore.setting:set_visible(false)
			return false -- Return false to stop the timer after executing once
		end)

		M.live(theme)
	elseif arg == "font" then -- Restore font settings
		local font_default = theme.font.font_default
		local theme = theme.load()
		local setting = require("lua.theme.setting")
		local setting = setting.load()

		write.write.config.theme(confPath, theme, theme, setting, font_default)

		label.theme_restore.font:set_visible(true)

		local timer_id
		timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
			label.theme_restore.font:set_visible(false)
			return false -- Return false to stop the timer after executing once
		end)

		M.live(theme)
	end
end

return M
