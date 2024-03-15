-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GLib = require("lgi").GLib

-- Import widgets
local widget = require("lua.widgets.box")
local notebook = require("lua.widgets.notebook")
local combo = require("lua.widgets.combo")
widget.grid = require("lua.widgets.grid")

-- Import custom functions
local list = require("lua.terminal.listFiles")
local var = require("lua.config.init")
local update = require("lua.theme.update")

-- Import theme
local theme = require("lua.theme.default").load()
local font = require("lua.theme.default").font.load()

-- Import mkdir function
local mkdir = require("lua.terminal.mkdir").mkdir
local rmdir = require("lua.terminal.mkdir").rmdir
local fileExist = require("lua.fileExist")

-- Import style function for themes
local style = require("lua.widgets.setting")

-- Function to load config file
local loadConfig = require("lua.loadConfig").load_config

-- function to look for even number
local function isEven(number)
	return number % 2 == 0
end

-- Function to update the wordlist file with new entries
local function write_update_wordlist(wordlist, words, check, delete)
	-- Determines to delete word or not
	local delete = delete or 0
	if delete == 1 then
		formatList = words
	else
		-- Checks if custom wordlist exist
		local wordDir_alt = var.wordDir_alt .. "/" .. wordlist .. ".lua"
		if fileExists(wordDir_alt) then
			-- load the wordlist
			local wordlist = loadConfig(wordDir_alt)
			formatList = wordlist
		else
			if check then -- Checks if the wordlist has multiple subfiles
				-- so it saves them all in one file and combine them in your home dir
				-- Import the chosen wordlist
				formatList = require(var.wordMod .. "." .. wordlist).all
			else
				-- Import the chosen wordlist
				formatList = require(var.wordMod .. "." .. wordlist)
			end
		end

		-- Loop through the new list to add
		for i = 1, #words do
			-- Gets the diffrent words
			local azerbaijani = words[i][1]
			local english = words[i][2]

			-- Add the new entry to the wordlist
			table.insert(formatList, { azerbaijani, english })

			checkMultiple = false
		end
	end

	--for i = 1, #formatList do
	--	print(i, formatList[i][1])
	--end

	-- Create custom word path if it doesn't exist
	if not fileExists(var.wordDir_alt) then
		mkdir(var.wordDir_alt)
	end

	if not formatList then
		formatList = {}
	end

	if #formatList == 0 then
		rmdir(var.wordDir_alt .. "/" .. wordlist .. ".lua") -- Remove the file if it gets empty
	else
		-- Serialize the updated wordlist and write it back to the file
		local file = io.open(var.wordDir_alt .. "/" .. wordlist .. ".lua", "w")
		if file then
			file:write("local wordlist = {\n")
			for _, entry in ipairs(formatList) do
				file:write(string.format('\t{ "%s", "%s" },\n', entry[1], entry[2]))
			end
			file:write("}\n\nreturn wordlist")
			file:close()

			-- Prints to the terminal
			print("Wordlist updated successfully!")
		end
	end

	-- Table to pass to the combo update function
	local inputCount = {
		activeWord = combo.word:get_active(),
		modelWord = combo.word_list_model,
		module = var.wordMod,
		word_count_set = config.word_count_set,
	}

	-- Sets the wordlist count when adding new words
	-- so it updates whill app is running
	combo.count = combo:new(inputCount)
	combo.count:set_count() -- Update the combo.count with the new words
end

-- Creating empty tables -- start {{{
-- Import table to store wordlist variables
local import_wordlist = {}
import_wordlist.count = 0

local M = {
	-- Notebook widget
	notebook = {},

	-- Main box for the items
	box = {},
	wordList_items = {},

	-- Create some grids used
	grid_main = {}, -- Main grid tto attach child grid
	grid_items = {}, -- Grid to attach the words
	grid_buttons = {}, -- Grid to attach add buttons
	grid_remove = {}, -- Grid to attach remove Button

	-- Entry widget
	entry_items = {
		firsten = {}, -- English words
		firstaz = {}, -- English words
	},              -- Entry widget to add word
	entry_remove = {}, -- Entry widgets to remove words
	import_items = {},
	new_list = {},

	-- Create table for remove button
	removeButton = {},
	addButton = {},
	submitButton = {},

	-- Table to create label list
	label_list = {
		remove = {},
	},

	-- Table for custom wordlist
	custom_wordlist = {},
}
--- }}} empty tables end

-- List all available lists
local directoryPath = var.wordDir
local luaFiles = list.dir(directoryPath)

---- Table for values not to add to custom list
local dontAdd = {}

-- Set count values to count the custom wordlist
local countCustom = 0

-- Check for custom wordlist
update.check_custom_list(countCustom, luaFiles, M, dontAdd)

-- Create a notebook for the wordlist
M.notebook.word = Gtk.Notebook.new()
M.notebook.word:set_tab_pos(Gtk.PositionType.LEFT) -- Set position

-- Create a scrolled window
local scrolledWindow = Gtk.ScrolledWindow({
	hscrollbar_policy = Gtk.PolicyType.NEVER,
	vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
	min_content_width = 1, -- Minimum width of the scrolled window
	min_content_height = 500,
})

-- Create button to add new wordlist
local addWordListButton = Gtk.Button({ label = "Add New Wordlist", margin_bottom = 5, margin_top = 20 })
local addWordListEntry = Gtk.Entry({ placeholder_text = "Wordlist Name" })

-- Action for new word list button
local function new_wordList_action_first()
	if addWordListButton.label == "Submit" then -- If
		addWordListButton:set_label("Add New Wordlist")
		addWordListButton:set_margin_top(0)
		widget.box_word_list:remove(addWordListButton)
		widget.box_word_list:remove(scrolledWindow)
		widget.box_word_list:remove(addWordListEntry)
		widget.box_word_list:append(addWordListButton)
		widget.box_word_list:append(scrolledWindow)
		local choice_entry = addWordListEntry.text
		local add_window = require("lua.widgets.menu.newList")

		if choice_entry ~= "" then
			add_window.new_word_list(choice_entry)
		end
	else
		addWordListButton:set_label("Submit")
		addWordListButton:set_margin_top(0)
		widget.box_word_list:remove(addWordListButton)
		widget.box_word_list:remove(scrolledWindow)
		widget.box_word_list:append(addWordListEntry)
		widget.box_word_list:append(addWordListButton)
		widget.box_word_list:append(scrolledWindow)
	end
end

-- Attach the function to the button
function addWordListButton:on_clicked()
	new_wordList_action_first()
end

-- Add notebook widget to the scrolled window
scrolledWindow:set_child(M.notebook.word)

-- Append the scroll window and button
widget.box_word_list:append(addWordListButton)
widget.box_word_list:append(scrolledWindow)

-- Start for loop to start creating the grids
for i, item_label in ipairs(luaFiles) do
	local checkMultiple = false            -- Check if the wordlist has multiple subfiles
	local wordList = list.modify(item_label) -- Modyfies the wordlist name
	local match = string.match(wordList, "_") -- if the wordlist ends with _ then next if statement will run

	-- If match is not nil
	if match ~= nil then
		wordList = item_label
	end

	-- Create box widget for all items
	M.box[i] = Gtk.Box({
		orientation = Gtk.Orientation.VERTICAL,
		spacing = 5,
		halign = Gtk.Align.CENTER,
		valign = Gtk.Align.START,
		hexpand = false,
		vexpand = false,
	})

	M.removeButton[i] = Gtk.Button({ label = "Remove Word" })
	M.label_list.remove[i] = Gtk.Label({ label = "Write index of word\n you want to Delete", margin_top = 50 })

	M.label_list.remove[i]:set_markup(
		"<span size='"
		.. font.fg_size
		.. "' foreground='"
		.. theme.label_welcome
		.. "'>"
		.. M.label_list.remove[i].label
		.. "</span>"
	)

	-- creates widgets notebook and grid widgets for all the words
	M.notebook.word:append_page(M.box[i], Gtk.Label({ label = wordList }))

	-- Create grid widgets
	M.grid_items[i] = widget.grid:main_create()
	M.grid_main[i] = widget.grid:main_create()
	M.grid_remove[i] = widget.grid:main_create()

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

	-- Append to the box widget
	M.box[i]:append(label_az)
	M.box[i]:append(spacer)
	M.box[i]:append(M.grid_main[i])

	if import_wordlist.count == 0 then
		import_wordlist.count = 1
	elseif import_wordlist.count == nil then
		import_wordlist.count = 1
	end

	-- Function to import the lists thats available
	import_wordlist = update.import_wordlists(dontAdd, M, import_wordlist.count, wordList, i)

	-- Create grid widget for buttons
	M.grid_buttons[i] = widget.grid:main_create()
	M.grid_buttons[i]:set_hexpand(true)

	-- Create empty table for entry widgets
	M.entry_items.azerbajaniEntry = {} -- Azerbajani words
	M.entry_items.englishEntry = {} -- English words

	-- Sets the first entry boxes to add a new word
	local entry_az = Gtk.Entry({ margin_top = 50, placeholder_text = "Azerbajani Word" })
	local entry_eng = Gtk.Entry({ margin_top = 50, placeholder_text = "English Word" })

	-- Add the entries to the table
	M.entry_items.firstaz[i] = entry_az
	M.entry_items.firsten[i] = entry_eng

	-- Entry box to remove word
	M.entry_remove[i] = Gtk.Entry({ placeholder_text = "Remove Word: Write Number" })

	-- Create submit and add button for the grid
	local submit = Gtk.Button({ label = "Submit" })
	local addButton = Gtk.Button({ margin_top = 50, label = "Add" })
	M.addButton[i] = addButton
	M.submitButton[i] = submit

	-- Make all dirs to lowercase
	local lower = wordList:lower()

	-- Check if there is multiple subdirs
	update.check_mult_subdir(directoryPath, lower, M, wordList)

	local success = pcall(function()
		NewSubDir = list.dir(directoryPath .. "/" .. lower)
	end)

	if not M.check then
		checkMultiple = M.check or false
	elseif success then
		checkMultiple = M.check or true
	else
		checkMultiple = M.check or false
	end

	-- Attach widgets to the button grid
	M.grid_buttons[i]:attach(entry_az, 1, 0, 1, 1)
	M.grid_buttons[i]:attach(entry_eng, 2, 0, 1, 1)
	M.grid_buttons[i]:attach(addButton, 3, 0, 1, 1)
	M.grid_buttons[i]:attach(submit, 0, 1, 4, 1)

	-- Set margin on submit button
	submit:set_margin_top(0)

	-- Attach the child to the main grid
	M.grid_main[i]:attach(M.grid_remove[i], 4, 3, 20, 1) -- attach grid for button
	M.grid_main[i]:attach(M.grid_buttons[i], 4, 2, 20, 1) -- attach grid for button
	M.grid_main[i]:attach(M.grid_items[i], 1, 1, 20, 1) -- attach grid for words

	-- Sets count to 0 at first
	local entryCount = 0
	local firstRun = true

	-- Create table to store the buttons
	local button_table = {}
	local entry_table = {}

	-- Function for add button
	local function add_button_action()
		local theme = require("lua.theme.default").load()
		-- Keep track of how many you add
		entryCount = entryCount + 1
		-- Will create new button for everytime you add a new word
		button_table[entryCount] = Gtk.Button({ label = "Add" })
		entry_table[entryCount] = Gtk.Button({ margin_top = 50, label = "X" })

		local add = button_table[entryCount]
		local remove = entry_table[entryCount]

		M.entry_items.azerbajaniEntry[entryCount] = Gtk.Entry({ placeholder_text = "Azerbajani Word" })
		M.entry_items.englishEntry[entryCount] = Gtk.Entry({ placeholder_text = "English Word" })

		M.entry_items.englishEntry[entryCount] = style.set_theme(M.entry_items.englishEntry[entryCount], {
			{
				size = font.fg_size / 1000,
				color = theme.label_question,
				border_color = theme.label_fg,
			},
		})

		M.entry_items.azerbajaniEntry[entryCount] = style.set_theme(M.entry_items.azerbajaniEntry[entryCount], {
			{
				size = font.fg_size / 1000,
				color = theme.label_question,
				border_color = theme.label_fg,
			},
		})

		add = style.set_theme(add, {
			{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
		})

		M.grid_buttons[i]:attach(M.entry_items.azerbajaniEntry[entryCount], 1, entryCount, 1, 1)
		M.grid_buttons[i]:attach(M.entry_items.englishEntry[entryCount], 2, entryCount, 1, 1)
		M.grid_buttons[i]:remove(submit)
		M.grid_buttons[i]:attach(submit, 0, entryCount + 1, 4, 1)

		-- Schedule removal and reattachment of the "Add" button
		GLib.idle_add(GLib.PRIORITY_DEFAULT, function()
			-- Remove and reattach the "Add" button
			-- If first time then it will remove the first button created
			if firstRun then
				M.grid_buttons[i]:remove(addButton)
				firstRun = false
			else
				-- else it will remove the other buttons
				M.grid_buttons[i]:remove(button_table[entryCount - 1])
			end
			M.grid_buttons[i]:attach(button_table[entryCount], 3, entryCount, 1, 1)
			M.grid_buttons[i]:attach(entry_table[entryCount], 3, entryCount - 1, 1, 1)
			entry_table[entryCount]:set_margin_top(0)
			entry_table[1]:set_margin_top(50)
			-- Restore scroll position
			return false -- Stop the idle handler
		end)

		addButton:set_margin_top(0)

		-- Attach the function
		function add:on_clicked()
			add_button_action()
		end

		function remove:on_clicked()
			-- Function for remove entry section
			local function remove_entry_action()
				local azEntry = M.grid_buttons[i]:get_child_at(1, entryCount)
				local enEntry = M.grid_buttons[i]:get_child_at(2, entryCount)
				local entry = M.grid_buttons[i]:get_child_at(3, entryCount - 1)
				local button = M.grid_buttons[i]:get_child_at(3, entryCount)
				entryCount = entryCount - 1
				if entryCount == 0 then
					M.grid_buttons[i]:remove(azEntry)
					M.grid_buttons[i]:remove(enEntry)
					M.grid_buttons[i]:remove(entry)
					M.grid_buttons[i]:remove(button)
					M.grid_buttons[i]:attach(addButton, 3, entryCount, 1, 1)
					addButton:set_margin_top(50)
					firstRun = true
				else
					M.grid_buttons[i]:remove(entry)
					M.grid_buttons[i]:remove(azEntry)
					M.grid_buttons[i]:remove(enEntry)
					M.grid_buttons[i]:remove(button)
					M.grid_buttons[i]:attach(button_table[entryCount], 3, entryCount, 1, 1)
				end
			end

			remove_entry_action()
		end
	end

	-- Attach the function to the add button
	function addButton:on_clicked()
		-- Calls the function
		add_button_action()
	end

	-- Clear the grid function
	local function clear_grid(grid)
		local child = grid:get_last_child()
		while child do
			grid:remove(child)
			child = grid:get_last_child()
		end
	end
	-- function on submit button
	function submit:on_clicked()
		-- Reset the counters
		firstRun = true
		entryCount = 0
		clear_grid(M.grid_buttons[i])

		-- Reattach the default buttons
		M.grid_buttons[i]:attach(entry_az, 1, 0, 1, 1)
		M.grid_buttons[i]:attach(entry_eng, 2, 0, 1, 1)
		M.grid_buttons[i]:attach(addButton, 3, 0, 1, 1)
		M.grid_buttons[i]:attach(submit, 0, 1, 4, 1)
		-- Sets margin
		addButton:set_margin_top(50)

		-- Create table to store the added words
		local combTable = {}

		-- For the first entry box
		local aze = entry_az.text
		local eng = entry_eng.text

		-- Checks if value is empty
		if aze ~= "" and eng ~= "" then
			table.insert(combTable, { aze, eng })
		end

		-- For the rest
		for key, value in pairs(M.entry_items.azerbajaniEntry) do
			local aze = M.entry_items.azerbajaniEntry[key].text
			local eng = M.entry_items.englishEntry[key].text
			-- Checks if value is empty
			if aze ~= "" and eng ~= "" then
				table.insert(combTable, { aze, eng })
			end
		end

		-- update the wordlist
		write_update_wordlist(wordList, combTable, checkMultiple)

		update.update_word_list()

		aze, eng = nil, nil

		for key, value in pairs(M.entry_items.azerbajaniEntry) do
			M.entry_items.azerbajaniEntry[key].text = ""
			M.entry_items.englishEntry[key].text = ""
		end

		entry_az.text = ""
		entry_eng.text = ""
	end

	local function isEven(number)
		return number % 2 == 0
	end

	-- Starts adding the words to the grid
	-- Running function from lua.theme.update
	num = update.create_wordlist_grid(M, M, wordList, isEven, i)

	update.set_grid_theme(M, i)

	-- Attach widgets to remove button
	M.grid_remove[i]:attach(M.label_list.remove[i], 1, 0, 10, 1)
	M.grid_remove[i]:attach(M.entry_remove[i], 1, 1, 1, 1)
	M.grid_remove[i]:attach(M.removeButton[i], 3, 1, 4, 1)

	-- Create temp variable for remove button
	local removeButton = M.removeButton[i]

	-- Function to remove words and attach the function to a button
	function removeButton:on_clicked()
		-- Count the words
		local countRem = 0
		-- Runs if this is a table and not nil
		if type(M.import_items[wordList]) == "table" then
			local choice = M.entry_remove[i].text
			if choice ~= "" then
				local indices = {}
				local firstRun = true
				for index in string.gmatch(choice, "%d+") do
					if firstRun then
						First = tonumber(index)
						firstRun = false
					end
					table.insert(indices, tonumber(index))
					Last = tonumber(index)
				end
				local suc, res = pcall(function()
					for j = 1, Last do
						if j >= First then
							print(j)
							table.remove(M.wordList_items[i], j)
						end
						if j == Last then
							print(j)
							table.remove(M.wordList_items[i], j)
						end
					end
				end)

				write_update_wordlist(wordList, M.wordList_items[i], checkMultiple, 1)
				update.update_word_list()

				Last, First, firstRun = 0, 0, true
			end
		else -- else will run this
			local choice = M.entry_remove[i].text
			if choice ~= "" then
				local indices = {}
				local firstRun = true
				for index in string.gmatch(choice, "%d+") do
					if firstRun then
						First = tonumber(index)
						firstRun = false
					end
					table.insert(indices, tonumber(index))
					Last = tonumber(index)
				end
				local suc, res = pcall(function()
					for j = 1, Last do
						if j >= First then
							print(j)
							table.remove(M.wordList_items[i], j)
						end
						if j == Last then
							print(j)
							table.remove(M.wordList_items[i], j)
						end
					end
				end)

				write_update_wordlist(wordList, M.wordList_items[i], checkMultiple, 1)
				update.update_word_list()
				Last, First, firstRun = 0, 0, true
			end
		end
	end
end

-- Some examples on how to use menu widgets
---- Connect the "activate" signal of the menu items to a callback function
--function M.newItem:on_activate()
--   label.label = "New menu item selected"
--end
--
--M.openItem.on_activate = function()
--   M.label.label = "Open menu item selected"
--end
--
--M.saveItem.on_activate = function()
--   M.label.label = "Save menu item selected"
--end
--
--function M.exitItem:on_activate()
--      print("exit")
--end

-- Create popover
--M.popover = Gtk.Popover({
--	relative_to = window,
--})
--
---- Create menubar
--M.menuBar = Gtk.MenuButton({ label = "File", popover = M.popover })

-- Create a label to display the selected menu item
--M.label = Gtk.Label({ label = "No menu item selected" })

return M -- Return the table
