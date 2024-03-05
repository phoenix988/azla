-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GLib = require("lgi").GLib
local theme = require("lua.theme.default")
local update = require("lua.theme.update")
local array = require("lua.widgets.setting")
local fileExists = require("lua.fileExist").fileExists
local mkdir = require("lua.terminal.mkdir").mkdir
local question = require("lua.question.main")
local label = require("lua.widgets.label")
local treeView = require("lua.widgets.button.treeView")

-- Import Variables
local var = require("lua.config.init")

local M = {}

local confPath = var.config.custom
local confDir = var.config.dir

-- Function to convert rgb to hash values
local function RGBToHash(red, green, blue)
	-- Convert the RGB components to their hexadecimal representations
	local redHex = string.format("%02X", red)
	local greenHex = string.format("%02X", green)
	local blueHex = string.format("%02X", blue)

	-- Concatenate the hexadecimal values and prepend '#'
	local hash = "#" .. redHex .. greenHex .. blueHex

	return hash
end

local function backAction(currentQuestion, question, window_alt, win, import, mainWin)
	local json = require("lua.question.save")

	-- Resets the variables that keep tracks of current
	-- question and correct answers
	question.correct = 0
	question.incorrect = 0

	question.jsonSettings.count_start = question.count_start

	-- Make these variables empty to avoid stacking
	question.label_correct = nil
	question.label_incorrect = nil

	window_alt.windowState = win:is_fullscreen()
	window_alt.windowStateMax = win:is_maximized()

	-- Make sure the entry fields are not empty when restoring session
	for i = 1, math.min(#question.word, question.last) do
		local choice = question.widget.entry_fields[i].text:lower()

		-- Remove leading spaces
		local choice = string.gsub(choice, "^%s*", "")

		-- Remove trailing spaces
		local choice = string.gsub(choice, "%s*$", "")

		if question.jsonSettings.entry ~= nil then
			question.jsonSettings.entry[choice] = i
		end
	end

	question.jsonSettings.treeViewCheck = {}

	for i = 1, math.min(#question.word, question.last) do
		local choice = question.widget.entry_fields[i].text:lower()
		local word = question.word[i][question.langVer]
		local word = string.gsub(word, " ✓ ", "")
		question.jsonSettings.treeViewCheck[word] = question.checkForMultiple[word]
	end

	json.saveSession(question.jsonSettings)

	question.jsonSettings = {}

	-- resets current question
	question.current = 0
	currentQuestion = 1 -- Start from the first question

	question.jsonSettings.lang = nil

	import.setQuestion(currentQuestion)

	win:destroy()
	mainWin:activate()
end

-- Function for the question window
function M.back_exit_create(currentQuestion, question, import, win, mainWin, replace, cacheFile, combo, window_alt)
	-- Create back button
	local backButton = Gtk.Button({ label = "Go Back", width_request = 300 })

	-- Makes exit button to exit
	local exitButton = Gtk.Button({ label = "Exit" })

	-- Defines the function of Exitbutton
	-- Function for back button for the question window
	function backButton:on_clicked()
		backAction(currentQuestion, question, window_alt, win, import, mainWin)
	end

	-- Function for exit button for the question window
	function exitButton:on_clicked()
		local mainWindowModule = require("lua.main")
		local write = require("lua.config.init")
		local getDim = mainWindowModule.getWindowDim
		local window = getDim()
		local json = require("lua.question.save")

		window.width = win:get_allocated_width()
		window.height = win:get_allocated_height()

		question.jsonSettings.count_start = question.count_start

		-- Make sure the entry fields are not empty when restoring session
		for i = 1, math.min(#question.word, question.last) do
			local choice = question.widget.entry_fields[i].text:lower()

			-- Remove leading spaces
			local choice = string.gsub(choice, "^%s*", "")

			-- Remove trailing spaces
			local choice = string.gsub(choice, "%s*$", "")

			if question.jsonSettings.entry ~= nil then
				question.jsonSettings.entry[choice] = i
			end
		end

		question.jsonSettings.treeViewCheck = {}

		for i = 1, math.min(#question.word, question.last) do
			local choice = question.widget.entry_fields[i].text:lower()
			local word = question.word[i][question.langVer]
			local word = string.gsub(word, " ✓ ", "")
			question.jsonSettings.treeViewCheck[word] = question.checkForMultiple[word]
		end

		json.saveSession(question.jsonSettings)

		question.jsonSettings = {}

		write.write.cache.config_main(cacheFile, combo)

		win:destroy()
		mainWin:quit()
	end

	return { exit = exitButton, back = backButton }
end

-- click actions for the main window
function M.click_action(widget, image, label, theme, setting, write)
	-- keep track of the widgets to show and hide
	button.setting_wordlist_count = 0

	-- Creates the setting button click event
	function button.setting:on_clicked()
		local hideBox = widget.hideBox

		for i = 1, #hideBox do
			-- Initally hide the theme box
			local hide = hideBox[i][1]
			hide:set_visible(true)
		end

		widget.box_second:set_visible(true)
		widget.box_first:set_visible(false)
		widget.box_second:set_halign(Gtk.Align.CENTER)
		widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
		image:set_visible(true)

		button.setting:set_visible(false)

		notebook.theme:set_current_page(2)
	end

	function button.setting_wordlist:on_clicked()
		if button.setting_wordlist_count == 0 then
			notebook.wordlist:set_visible(true)
			button.setting_wordlist_count = 1
            button.setting_wordlist:set_label("Hide WordList")
		elseif button.setting_wordlist_count == 1 then
			notebook.wordlist:set_visible(false)
            button.setting_wordlist:set_label("Show WordLists")
			button.setting_wordlist_count = 0
		end
	end

	-- Creates the back button function
	function M.setting_back:on_clicked()
		widget.box_theme:set_visible(false)
		widget.box_theme_alt:set_visible(false)
		widget.box_theme_main:set_visible(false)
		widget.box_theme_button:set_visible(false)
		widget.box_theme_label:set_visible(false)
		label.theme_apply:set_visible(false)
		widget.box_third:set_visible(false)
		widget.box_second:set_visible(true)
		widget.box_first:set_visible(true)
		button.setting:set_visible(true)
		widget.box_main:set_spacing(10)
		widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
		widget.box_second:set_halign(Gtk.Align.FILL)
		image:set_visible(false)
	end

	function M.setting_submit:on_clicked()
		local apply = {}
		local apply_setting = {}
		local apply_font = {}

		local font = require("lua.theme.font")
		local font = font.load()

		local setting = require("lua.theme.setting")
		local setting = setting.load()

		if not fileExists(confDir) then
			mkdir(confDir)
		end

		local colorTable = {}
		local settingTable = {}

		for key, value in pairs(theme) do
			local match = string.match(key, "size")
			local matchColor = string.match(value, "#")

			-- Runs this if the value is a color
			if matchColor then
				local color = array.theme_labels[key]:get_rgba()
				local red = math.floor(color.red * 255)
				local green = math.floor(color.green * 255)
				local blue = math.floor(color.blue * 255)
				local hash = RGBToHash(red, green, blue)

				theme_choice = hash
			else
				theme_choice = array.theme_labels[key].text:lower()
			end

			-- Reduce the number so its easier to modify size
			if match == "size" then
				theme_choice = theme_choice * 1000
			end

			apply[key] = theme_choice
		end

		-- Gets the new font values
		for key, value in pairs(font) do
			local font_choice = array.theme_labels[key]:get_value()
			local font_choice = tostring(font_choice):gsub("%.0+$", "")
			local font_choice = font_choice * 1000
			apply_font[key] = font_choice
		end

		-- Write to config
		write.write.config.theme(confPath, apply, theme, setting, apply_font)

		-- Gets new config values
		for key, value in pairs(setting) do
			local setting_choice = array.setting_labels[key].text:lower()

			apply_setting[key] = setting_choice
		end

		write.write.config.setting(confPath, apply_setting, apply, apply_font)

		-- Sets label visible
		label.theme_apply:set_visible(true)

		-- sets timer to hide the label after 4 seconds
		local timer_id
		timer_id = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 4, function()
			label.theme_apply:set_visible(false)
			return false -- Return false to stop the timer after executing once
		end)

		-- Load theme
		local theme = require("lua.theme.default")
		local theme = theme.load()

		update.live(theme)
		update.live(apply)
	end

	function button.color_scheme:on_clicked()
		local theme = require("lua.theme.default")
		theme.color_scheme(treeView, write, update)
	end
end

-- Exit button function
function M.exit_click(window, write, win, cacheFile, combo)
	window.width = win:get_allocated_width()
	window.height = win:get_allocated_height()

	write.write.cache.config_main(cacheFile, combo)

	win:destroy()
end

-- Button create result
function M.result_create(result)
	button.result = Gtk.Button({ label = "Show Result" })

	-- Defines the function of Resultbutton
	function button.result:on_clicked()
		-- Import correct answers
		local question = require("lua.question.main")
		-- Runs the function show_result
		result(question.correct, question.incorrect)
	end
end

-- Function to create restart button for the question window
function M.restart_create(win, app2, currentQuestion, import, window_alt)
	-- Creates the restart button if you want to restart the list
	local restartButton = Gtk.Button({ label = "Restart" })
	-- Initially you wont see the restartbutton
	restartButton:set_visible(false)

	-- Function called when clicking the restartbutton
	function restartButton:on_clicked()
		-- Resets the variables that keep tracks of current
		-- question and correct answers
		question.correct = 0
		question.incorrect = 0

		-- resets current question
		question.current = 0
		currentQuestion = 1 -- Start from the first question if reached the end

		question.label_correct = {}
		question.label_incorrect = {}

		import.setQuestion(currentQuestion)

		window_alt.windowState = win:is_fullscreen()
		window_alt.windowStateMax = win:is_maximized()

		-- Relaunch the app
		win:destroy()
		app2:activate()
	end

	return { restart = restartButton }
end

-- Create summary and hidden buttons
function M.summary_create(grid1, grid2, wg, box)
	-- Creates summary button and hide button
	local summaryButton = Gtk.Button({ label = "Summary" })
	local hidesummaryButton = Gtk.Button({ label = "Hide", margin_top = 75 })

	-- Create continue button
	local continueButton = Gtk.Button({ label = "Continue", visible = false })

	-- Hides summary and hidesummary button initally
	summaryButton:set_visible(false)
	hidesummaryButton:set_visible(false)

	-- Create click action on summaryButton
	function summaryButton:on_clicked()
		-- Imports some modules
		local show = require("lua.summary.show")

		-- function to clear grid
		local function clear(grid)
			local child = grid:get_last_child()
			while child do
				grid:remove(child)
				child = grid:get_last_child()
			end
		end

		-- clears the grid
		clear(grid1)
		clear(grid2)

		-- shows the summary labels
		show.summary(question, grid1, grid2, theme)

		-- Hides and shows widgets
		grid1:set_visible(true)
		grid2:set_visible(true)
		box:set_visible(true)
		label.summary:set_visible(true)
		wg.labelEnd:set_visible(false)
		wg.labelEndCorrect:set_visible(false)
		wg.labelEndIncorrect:set_visible(false)
		button.result:set_visible(false)
		summaryButton:set_visible(false)
		hidesummaryButton:set_visible(true)
	end

	-- Create click action on hidesummaryButton
	function hidesummaryButton:on_clicked()
		-- Hides and shows widgets
		box:set_visible(false)
		label.summary:set_visible(false)
		wg.labelEnd:set_visible(true)
		wg.labelEndCorrect:set_visible(true)
		wg.labelEndIncorrect:set_visible(true)
		button.result:set_visible(true)
		summaryButton:set_visible(true)
		hidesummaryButton:set_visible(false)

		-- Hides the grids
		grid1:set_visible(false)
		grid2:set_visible(false)
	end

	-- return the buttons
	return { summary = summaryButton, hideSummary = hidesummaryButton }
end

return M
