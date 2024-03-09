-- Made by Phoenix988
---     .----------------.  .----------------.  .----------------.  .----------------.
---    | .--------------. || .--------------. || .--------------. || .--------------. |
---    | |      __      | || |   ________   | || |   _____      | || |      __      | |
---    | |     /  \     | || |  |  __   _|  | || |  |_   _|     | || |     /  \     | |
---    | |    / /\ \    | || |  |_/  / /    | || |    | |       | || |    / /\ \    | |
---    | |   / ____ \   | || |     .'.' _   | || |    | |   _   | || |   / ____ \   | |
---    | | _/ /    \ \_ | || |   _/ /__/ |  | || |   _| |__/ |  | || | _/ /    \ \_ | |
---    | ||____|  |____|| || |  |________|  | || |  |________|  | || ||____|  |____|| |
---    | |              | || |              | || |              | || |              | |
---    | '--------------' || '--------------' || '--------------' || '--------------' |
---    '----------------'  '----------------'  '----------------'  '----------------'

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = require("lgi").Gdk
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require("GdkPixbuf")
local lfs = require("lfs")
local os = require("os")

-- Import theme
local theme = require("lua.theme.default").load()

-- Import fonts
local font = require("lua.theme.default").font.load()

-- Imports some settings
local setting_default = require("lua.theme.setting").load()

-- Other imports and global variables
-- Imports function to create images
local create_image = require("lua.createImage").create_image

-- Imports window 2
local create_app2 = require("lua.questionMain").create_app2

-- import widgets and create a table
local import_widgets = require("lua.widgets.init")

-- Create widget list table
local widget_list = {}

-- Imports Config function that will load config files
-- Dont really need both functions they do the same thing
-- Will change it eventually when I try to optimize the app
local loadConfig = require("lua.loadConfig").load_config
local loadConfigCustom = require("lua.loadConfig").load_config_custom

-- Imports filexist module
local fileExist = require("lua.fileExist").fileExists

-- Import string functions for list.modify list.dir etc
-- So I can manipulate text and directories
local list = require("lua.terminal.listFiles")

-- Import keybindings
local lol = require("lua.bindings.init").lol

-- Import some functions to run when clicking buttons
local azla = require("lua.question.start")

-- Import function to write to cache file
local write = require("lua.config.init")

-- Import Variables
local var = require("lua.config.init")

-- Gets current directory
local currentDir = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentDir:match("(.*/)") or ""

-- Variable to store word paths and word modules
local luaWordsPath = var.wordDir
local luaWordsModule = var.wordMod

-- Adds some variables to the wordItems table
local wordItems = {
	list = list,
	path = luaWordsPath,
}

-- Sets default variable that will determine language choice
-- Needed for when you first launch the app
local exportLanguageChoice = "azerbajani"

-- Gets users home directory
local home = os.getenv("HOME")

-- Sets path to image
local imagePath = setting_default.image

-- Sets cachefile config path
local cacheFile = var.cacheFile

-- Sets path to customConfig where you can modify the theming of the app
local customConfig = var.config.custom

-- load cacheFile config
local configPath = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
	config = {}
end

-- Sets empty window table to be used
local window = {}

-- Variables tthat sets the application values
local appID1 = "io.github.Phoenix988.azla.main.lua"
local appTitle = "Azla"
local app1 = Gtk.Application({ application_id = appID1 })

-- Make a table of all widgets
for key, _ in pairs(import_widgets) do
	table.insert(widget_list, key)
end

-- Loops through them and shortens the name
for _, value in ipairs(widget_list) do
	_G[value] = import_widgets[value]
end

-- Creates the config array if the custom file exist
if fileExist(customConfig) then
	-- Load custom config
	local customPath = loadConfig(customConfig) -- Custom config exist
else
	-- Sets empty array if it doesnt exist
	local setting = {} --Custom config file doesn't exist
end

-- widgets to hide on startup
widget.hideBox = {
	{ widget.box_theme },
	{ widget.box_setting },
	{ widget.box_theme_alt },
	{ widget.box_theme_main },
	{ widget.box_theme_button },
	{ widget.box_theme_label },
}

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()
	-- Sets window size
	write.write.config.window_size(customConfig, setting, config, fileExist)

	-- Creates the window
	local win = Gtk.ApplicationWindow({
		title = appTitle,
		application = self,
		class = "Azla",
		default_width = config.default_width,
		default_height = config.default_height,
		on_destroy = Gtk.main_quit,
		decorated = true,
		deletable = true,
	})

	-- returns the window to be used later
	window.main = win

	-- Combo box --START
	-- Here I am configuiring the combo box widgets for Azla
	-- Where you make some choices in the app like choosing wordlist and language

	-- Model for the combo box
	combo:create_lang()

	-- Creates the instance of the combo class
	combo.set = combo:new(wordItems)

	-- Creates the wordlist box
	combo.set:create_word_list()

	-- Creates combo word count box
	combo:create_word_count()

	-- Sets default label when you launch the app
	local set = combo:set_default_label()

	-- Updates the label of word_list
	label.word_list.label = "WordList " .. set.wordActive .. " selected (" .. set.last_word_label .. ")"
	label.word_list:set_markup(
		"<span size='"
			.. font.word_size
			.. "' foreground='"
			.. theme.label_word
			.. "'>"
			.. label.word_list.label
			.. "</span>"
	)

	-- Creates a table to pass through the combo class
	local input = {
		activeWord = combo.word:get_active(),
		modelWord = combo.word_list_model,
		module = luaWordsModule,
		combo = combo,
		config = config,
		custom = customConfig,
		fileExist = fileExist,
	}

	-- Create all the combo words values on launch
	-- Creates the class instances
	combo.set = combo:new(input)

	-- Count instance
	combo.count = combo:new(input)

	-- Set count value
	combo.count:set_count_value()

	-- set value of lang combo box
	combo.set:set_value(combo.lang, config.lang_set)

	-- Changes the 'label' text when user change the combo box value
	-- Also updates the cache file so it remembers the last choice when you exit the app
	-- Runs when the lang box changes
	function combo.lang:on_changed()
		-- Reload theme
		local theme = require("lua.theme.default")
		local theme = theme.load()

		-- Gets the current active combo number
		local n = self:get_active()

		window.width = win:get_allocated_width()
		window.height = win:get_allocated_height()

		label.language.label = "Option " .. n .. " selected (" .. combo.lang_items[n + 1] .. ")"
		label.language:set_markup(
			"<span size='"
				.. font.lang_size
				.. "' foreground='"
				.. theme.label_lang
				.. "'>"
				.. label.language.label
				.. "</span>"
		)

		if n == 0 then
			-- Determines which languages to use
			-- Will use azerbajani export the var
			exportLanguageChoice = "azerbajani"
		elseif n == 1 then
			-- Determines which languages to use
			-- Will use english and export the var
			exportLanguageChoice = "english"
		end

		-- Updates cachefile
		write.write.cache.config_main(cacheFile, combo)
	end

	-- Changes the 'label' text when user change the combo box value
	-- Also updates the cache file so it remembers the last choice when you exit the app
	-- Runs when combo word list changes
	function combo.word:on_changed()
		local theme = require("lua.theme.default")
		local theme = theme.load()

		window.width = win:get_allocated_width()
		window.height = win:get_allocated_height()

		loadConfig(cacheFile)

		local n = self:get_active()

		write.write.cache.config_main(cacheFile, combo)

		-- Only get the list name
		newStr = combo.word_files[n + 1]

		if newStr then
			last = list.modify(newStr)
		end

		-- Updates label when you change option
		if last then
			label.word_list.label = "WordList " .. n .. " selected (" .. last .. ")"
			label.word_list:set_markup(
				"<span size='"
					.. font.word_size
					.. "' foreground='"
					.. theme.label_word
					.. "'>"
					.. label.word_list.label
					.. "</span>"
			)
		end

		-- updates the combo boxes
		local inputCount = {
			activeWord = combo.word:get_active(),
			modelWord = combo.word_list_model,
			module = luaWordsModule,
			word_count_set = config.word_count_set,
		}

		-- Sets the wordlist count when value changes
		combo.count = combo:new(inputCount)
		combo.count:set_count()
	end

	-- set value of word count combo box
	combo.set:set_value(combo.word_count, config.word_count_set)

	-- set value of word combo box
	combo.set:set_value(combo.word, config.word_set)

	-- Function that runs when combo word count changes
	function combo.word_count:on_changed()
		-- Reload theme
		local theme = require("lua.theme.default")
		local theme = theme.load()

		local n = self:get_active()

		window.width = win:get_allocated_width()
		window.height = win:get_allocated_height()

		-- Removes any error message that could ocur when setting the count
		local success, result = pcall(function()
			-- Code that uses the variable
			label.word_count.label = "Selected " .. combo.word_count_items[n + 1] .. " Words"
			label.word_count:set_markup(
				"<span size='"
					.. font.word_size
					.. "' foreground='"
					.. theme.label_word
					.. "'>"
					.. label.word_count.label
					.. "</span>"
			)
		end)

		write.write.cache.config_main(cacheFile, combo)
	end

	-- Exports the default language option on startup
	local lang_value = combo.lang:get_active()

	-- Sets language option on startup
	if lang_value == 0 then
		exportLanguageChoice = "azerbajani"
	elseif lang_value == 1 then
		exportLanguageChoice = "english"
	end

	--Combo --END

	-- Returns some settings start
	-- Gets the active items in the combo boxes
	-- And stores it in settings just so we dont get errors
	-- Sometimes I got some errors when Launching the app
	-- If I didn't set these
	-- settings start
	settings = {}
	
	-- adds the active wordlist and stores it in settings table
	settings.word = combo.word:get_active()
    
	-- adds the active lang and stores it in settings table
	settings.lang = combo.lang:get_active()
	settings.comboWord = comboWord

	-- adds the active word_count and stores it in settings
	settings.word_count = combo.word_count:get_active()
	-- settings end

	-- Sets function to run when you click the exit button
	function button.exit:on_clicked()
		button.exit_click(window, write, win, cacheFile, combo)
	end

	function button.exit_alt:on_clicked()
		button.exit_click(window, write, win, cacheFile, combo)
	end

	-- Create the function when you press on start
	function button.start:on_clicked()
		azla.start_azla(false, win, window, create_app2, luaWordsModule)
	end

	-- Create function for exam mode similar to practice mode
	-- But you will see your result in the end only
	function button.exam_mode:on_clicked()
		azla.start_azla(true, win, window, create_app2, luaWordsModule)
	end

	function button.restore_mode:on_clicked()
		azla.load_session(false, win, window, create_app2, luaWordsModule)
	end

	-- Create an accelerator group
	local keyPress = Gtk.EventControllerKey()

	-- Connect the 'key-pressed' signal to the callback function
	keyPress.on_key_pressed = lol

	-- Add the event controller to the window
	win:add_controller(keyPress)

	-- Creates the images
	local image = create_image(imagePath)
	local image2 = create_image(imagePath)

	-- Hide Image 2
	image2:set_visible(false)

	-- Sets the size of the image
	image:set_size_request(200, 150)
	image2:set_size_request(200, 150)

	-- apend widgets to box theme
	--widget.box_theme_main:append(image2)
	--widget.box_theme_main:append(label.theme)

	-- Create listBox
	local listBox = import_widgets.listBox:create()
	local listTree = import_widgets.listBox:create_tree()

	local schemeGrid = grid.main_create()

	-- Get active value of the treeview
	local selection = listTree:get_selection()
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

	widget.box_theme:append(schemeGrid)

	-- attach widgets to the schemegrid
	schemeGrid:attach(listTree, 0, 0, 1, 1)
	schemeGrid:attach(label.current_color_scheme, 1, 0, 1, 1)
	--schemeGrid:attach(button.color_scheme, 0,1,1,1)

	schemeGrid:set_margin_bottom(20)

	-- Create theme entry boxes
	local list1 = array.theme_table(theme, font)

	-- Create default setting empty boxes
	local list2 = array.setting_table(theme, font)

	-- Create font setting boxes
	local list3 = array.font_table(theme, font)

	-- Create a scrolled window
	local scrolledWindow = Gtk.ScrolledWindow()
	local scrolledTheme = Gtk.ScrolledWindow({
		hscrollbar_policy = Gtk.PolicyType.NEVER,
		vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
	})

	-- Set the text view as the child of the scrolled window
	scrolledWindow:set_child(widget.box_main)

	-- Create notebook widgets
	notebook:create()
	settings.notebook = notebook

	-- Make the notebook scrollable
	scrolledTheme:set_child(themeGrid)

	-- Creates some grids
	local mainGrid = grid.main_create()
	local themeGrid = grid.main_create()

	-- Attach all the widgets to the mainGrid
	mainGrid:attach(label.welcome, 0, 2, 1, 1)
	mainGrid:attach(label.language, 0, 3, 1, 1)
	mainGrid:attach(combo.lang, 0, 4, 1, 1)
	mainGrid:attach(label.word_list, 0, 5, 1, 1)
	mainGrid:attach(combo.word, 0, 6, 1, 1)
	mainGrid:attach(label.word_count, 0, 7, 1, 1)
	mainGrid:attach(combo.word_count, 0, 8, 1, 1)
	mainGrid:attach(button.start, 0, 11, 1, 1)
	mainGrid:attach(button.exam_mode, 0, 12, 1, 1)
	mainGrid:attach(button.restore_mode, 0, 13, 1, 1)
	mainGrid:attach(button.setting, 0, 14, 1, 1)
	mainGrid:attach(button.exit, 0, 15, 1, 1)

	--themeGrid:attach(button.setting_submit,0,0,1,1)
	themeGrid:attach(image2, 1, -2, 1, 1)
	themeGrid:attach(label.theme, 1, -1, 1, 1)
	themeGrid:attach(notebook.stackSwitcher, 1, 0, 1, 1)
	themeGrid:attach(notebook.stack, 1, 1, 1, 1)
	--themeGrid:attach(notebook.wordlist, 1, 2, 1, 1)
	--themeGrid:attach(button.setting_wordlist, 1, 4, 1, 1)
	themeGrid:attach(button.setting_back, 1, 6, 1, 1)
	themeGrid:attach(button.setting_submit, 1, 5, 1, 1)
	themeGrid:attach(button.exit_alt, 1, 7, 1, 1)
	themeGrid:attach(label.theme_apply, 1, 3, 1, 1)

	-- Hide wordlist on startup
	--notebook.wordlist:set_visible(false)

	-- appends all the widgets to make them wisible
	--widget.box_theme_main:append(scrolledTheme)
	widget.box_theme_button:append(themeGrid)

	-- Sets the size of the main theme box
	--widget.box_theme_main:set_size_request(750, 750)

	widget.image = image2
	widget.label = label

	-- Call some click actions
	button.click_action(widget, image2, label, theme, setting_default, write)
	-- Create Buttons --END

	-- Adds the widgets to the Main Box
	-- Add widgets to the main box
	-- first section is the widget and second one
	-- is which  box to append it to

	widget.append = {
		{ image, "main" },
		{ mainGrid, "main" },
	}

	-- appends all the widgets
	for i = 1, #widget.append do
		local check = widget.append[i][2]
		-- adds to the first box
		if check == "main" then
			widget.box_first:append(widget.append[i][1])
			-- adds to secondary box
		elseif check == check then
			widget.box_second:append(widget.append[i][1])
		end
	end

	-- Appends both boxes to the main one
	widget.box_main:append(widget.box_first)
	widget.box_main:append(widget.box_theme_main)
	widget.box_third:append(widget.box_theme_label)
	widget.box_main:append(widget.box_third)
	widget.box_main:append(widget.box_theme_button)
	widget.box_main:append(widget.box_second)

	-- Hides some widgets on startup
	-- stored in widget.hideBox
	local hideBox = widget.hideBox
	for i = 1, #hideBox do
		-- Initally hide the theme box
		local hide = hideBox[i][1]
		hide:set_visible(false)
	end

	-- Appends box to the main window
	win.child = scrolledWindow
end -- End of the app function

-- Returns some variables
-- Creates the function to import the language variable
function getLanguageChoice()
	return exportLanguageChoice
end

-- Returns wordlist
function getWordList()
	return wordlist
end

-- Returns the window height
function getWindowDim()
	return window
end

-- Returns some settings to be used
function getSettingList()
	return settings
end

-- Export the necessary functions and variables
return {
	app1 = app1,
	getWordList = getWordList,
	getWindowDim = getWindowDim,
	getSettingList = getSettingList,
	getLanguageChoice = getLanguageChoice,
}
