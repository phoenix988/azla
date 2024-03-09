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
local function updateWordlist(wordlist, words, check, delete)
	formatList = {}
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
		end
	end

	-- Create custom word path if it doesn't exist
	if not fileExists(var.wordDir_alt) then
		mkdir(var.wordDir_alt)
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
	combo.count:set_count()

	formatList = {}
end

-- Creating empty tables -- start {{{
local M = {}

-- Notebook widget
M.notebook = {}

-- Main box for the items
M.box = {}
M.wordList_items = {}

-- Create some grids used
M.grid_main = {}   -- Main grid tto attach child grid
M.grid_items = {}  -- Grid to attach the words
M.grid = {}        -- Grid to attach add buttons
M.grid_remove = {} -- Grid to attach remove Button

-- Entry widget
M.entry_items = {}         -- Entry widget to add word
M.entry_remove = {}        -- Entry widgets to remove words
M.entry_items.firstaz = {} -- Azerbajani words
M.entry_items.firsten = {} -- English words
M.import_items = {}
M.new_list = {}

-- Create table for remove button
M.removeButton = {}
M.addButton = {}
M.submitButton = {}

-- Table to create label list
M.label_list = {}
M.label_list.remove = {}

-- Table for custom wordlist
M.custom_wordlist = {}
--- }}} empty tables end

-- List all available lists
local directoryPath = var.wordDir
local luaFiles = list.dir(directoryPath)

---- Table for values not to add to custom list
local dontAdd = {}

-- Set count values to count the custom wordlist
local countCustom = 0
local countCustom_main = 0

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

-- Action to add when you press the button once
--local function new_wordList_action()
--	addWordListButton:set_label("Add New Wordlist")
--	addWordListButton:set_margin_top(0)
--	widget.box_word_list:remove(addWordListButton)
--	widget.box_word_list:remove(scrolledWindow)
--	widget.box_word_list:remove(addWordListEntry)
--	widget.box_word_list:append(addWordListButton)
--	widget.box_word_list:append(scrolledWindow)
--	function addWordListButton:on_clicked()
--		new_wordList_action_first()
--	end
--end

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

	-- Create grid widget
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

	-- Function to import the lists thats available
	update.import_wordlists(dontAdd, M, countCustom_main, wordList, i)

	-- Create grid widget for buttons
	M.grid[i] = widget.grid:main_create()
	M.grid[i]:set_hexpand(true)

	-- Create empty table for entry widgets
	M.entry_items.azerbajaniEntry = {} -- Azerbajani words
	M.entry_items.englishEntry = {} -- English words

	-- Sets the first entry boxes to add a new word
	local entry_az = Gtk.Entry({ margin_top = 50, placeholder_text = "Azerbajani Word" })
	local entry_eng = Gtk.Entry({ margin_top = 50, placeholder_text = "English Word" })

	M.entry_items.firstaz[i] = entry_az
	M.entry_items.firsten[i] = entry_eng

	-- Entry box to remove word
	M.entry_remove[i] = Gtk.Entry({ placeholder_text = "Remove Word: Write Number" })

	-- Set style of entry boxes
	M.entry_remove[i] = style.set_theme(M.entry_remove[i], {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	M.removeButton[i] = style.set_theme(M.removeButton[i], {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	entry_az = style.set_theme(entry_az, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	entry_eng = style.set_theme(entry_eng, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	-- Create submit and add button for the grid
	local submit = Gtk.Button({ label = "Submit" })
	local addAnother = Gtk.Button({ margin_top = 50, label = "Add" })
	M.addButton[i] = addAnother
	M.submitButton[i] = submit

	submit = style.set_theme(submit, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	addAnother = style.set_theme(addAnother, {
		{ size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg },
	})

	-- Make all dirs to lowercase
	local lower = wordList:lower()

	-- Check if there is multiple subdirs
	update.check_mult_subdir(directoryPath, lower, M, wordList)

	-- Attach widgets to the button grid
	M.grid[i]:attach(entry_az, 1, 0, 1, 1)
	M.grid[i]:attach(entry_eng, 2, 0, 1, 1)
	M.grid[i]:attach(addAnother, 3, 0, 1, 1)
	M.grid[i]:attach(submit, 0, 1, 4, 1)
	submit:set_margin_top(0)

	-- Attach the child grids
	M.grid_main[i]:attach(M.grid_remove[i], 1, 3, 20, 1) -- attach grid for button
	M.grid_main[i]:attach(M.grid[i], 1, 2, 6, 1)      -- attach grid for button
	M.grid_main[i]:attach(M.grid_items[i], 1, 1, 1, 1) -- attach grid for words
	--M.box[i]:append(M.grid[i])
	--M.box[i]:append(submit)

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

		M.grid[i]:attach(M.entry_items.azerbajaniEntry[entryCount], 1, entryCount, 1, 1)
		M.grid[i]:attach(M.entry_items.englishEntry[entryCount], 2, entryCount, 1, 1)
		M.grid[i]:remove(submit)
		M.grid[i]:attach(submit, 0, entryCount + 1, 4, 1)

		-- Schedule removal and reattachment of the "Add" button
		GLib.idle_add(GLib.PRIORITY_DEFAULT, function()
			-- Remove and reattach the "Add" button
			-- If first time then it will remove the first button created
			if firstRun then
				M.grid[i]:remove(addAnother)
				firstRun = false
			else
				-- else it will remove the other buttons
				M.grid[i]:remove(button_table[entryCount - 1])
			end
			M.grid[i]:attach(button_table[entryCount], 3, entryCount, 1, 1)
			M.grid[i]:attach(entry_table[entryCount], 3, entryCount - 1, 1, 1)
			entry_table[entryCount]:set_margin_top(0)
			entry_table[1]:set_margin_top(50)
			-- Restore scroll position
			return false -- Stop the idle handler
		end)

		addAnother:set_margin_top(0)

		-- Attach the function
		function add:on_clicked()
			add_button_action()
		end

		function remove:on_clicked()
			-- Function for remove entry section
			local function remove_entry_action()
				local azEntry = M.grid[i]:get_child_at(1, entryCount)
				local enEntry = M.grid[i]:get_child_at(2, entryCount)
				local entry = M.grid[i]:get_child_at(3, entryCount - 1)
				local button = M.grid[i]:get_child_at(3, entryCount)
				entryCount = entryCount - 1
				if entryCount == 0 then
					M.grid[i]:remove(azEntry)
					M.grid[i]:remove(enEntry)
					M.grid[i]:remove(entry)
					M.grid[i]:remove(button)
					M.grid[i]:attach(addAnother, 3, entryCount, 1, 1)
					addAnother:set_margin_top(50)
					firstRun = true
				else
					M.grid[i]:remove(entry)
					M.grid[i]:remove(azEntry)
					M.grid[i]:remove(enEntry)
					M.grid[i]:remove(button)
					M.grid[i]:attach(button_table[entryCount], 3, entryCount, 1, 1)
				end
			end

			remove_entry_action()
		end
	end

	-- Attach the function to the add button
	function addAnother:on_clicked()
		-- Calls the function
		add_button_action()
	end

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
		clear_grid(M.grid[i])

		-- Reattach the default buttons
		M.grid[i]:attach(entry_az, 1, 0, 1, 1)
		M.grid[i]:attach(entry_eng, 2, 0, 1, 1)
		M.grid[i]:attach(addAnother, 3, 0, 1, 1)
		M.grid[i]:attach(submit, 0, 1, 4, 1)

		addAnother:set_margin_top(50)

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
		updateWordlist(wordList, combTable, checkMultiple)

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
	if type(M.import_items[wordList]) == "table" then
		-- Keep track of even and uneven
		local countTime = 0
		-- Create final WordTable to add all words from the diffrent lists
		-- To one single table
		WordTable = {}
		for key, value in ipairs(M.new_list[wordList]) do
			if not isEven(key) then
				countTime = countTime + 1
				WordTable[countTime] = { M.new_list[wordList][key], M.new_list[wordList][key + 1] }
			end
		end

		-- Finally we create the diffrent labels for the words in the wordlist
		for j = 1, #WordTable do
			M.label_list[wordList] = {}
			local english = list.to_upper(WordTable[j][2])
			local aze = list.to_upper(WordTable[j][1])

			-- Make sure special characters also converts to uppercase
			local checkAz = list.lower_case(aze, 2)

			if checkAz ~= nil then
				aze = checkAz
			end

			local form = aze .. " : " .. english
			local row = math.floor((j - 1) / 3)
			local col = (j - 1) % 3
			local label = Gtk.Label({ label = j .. " " .. form })
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

			M.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)

			label:set_size_request(100, -1)
			M.label_list[wordList][j] = label

			function M.modify_label()
				M.label_list[wordList][j]:set_markup(
					"<span size='"
					.. font.word_list_size
					.. "' foreground='"
					.. theme.label_fg
					.. "'>"
					.. M.label_list[wordList][j].label
					.. "</span>"
				)
			end
		end
	else
		for j = 1, #M.wordList_items[i] do
			M.label_list[wordList] = {}
			local english = list.to_upper(M.wordList_items[i][j][2])
			local aze = list.to_upper(M.wordList_items[i][j][1])
			-- Make sure special characters also converts to uppercase
			local checkAz = list.lower_case(aze, 2)

			if checkAz ~= nil then
				aze = checkAz
			end

			local form = aze .. " : " .. english
			if wordList == "Phrases" then
				row = math.floor((j - 1) / 1)
				col = (j - 1) % 1
			else
				row = math.floor((j - 1) / 3)
				col = (j - 1) % 3
			end
			local label = Gtk.Label({ label = j .. " " .. form })

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

			label:set_size_request(100, -1)

			M.label_list[wordList][j] = label

			M.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)
		end
	end

	-- Attach widgets to remove button
	M.grid_remove[i]:attach(M.label_list.remove[i], 1, 0, 5, 1)
	M.grid_remove[i]:attach(M.entry_remove[i], 1, 1, 1, 1)
	M.grid_remove[i]:attach(M.removeButton[i], 2, 1, 1, 1)

	-- Create temp variable for rtemove button
	local removeButton = M.removeButton[i]

	-- Function to remove words and attach the function to a button
	function removeButton:on_clicked()
		-- Count the words
		local countRem = 0
		-- Runs if this is a table and not nil
		if type(M.import_items[wordList]) == "table" then
			-- Create empty table
			local WordTable = {}

			for key, value in ipairs(M.new_list[wordList]) do
				if not isEven(key) then
					countRem = countRem + 1
					WordTable[countRem] = { M.new_list[wordList][key], M.new_list[wordList][key + 1] }
				end
			end

			local choice = M.entry_remove[i].text
			if choice ~= "" then
				local start, finish = string.match(choice, "(%d+)-(%d+)")
				local start = tonumber(start)
				local finish = tonumber(finish)

				table.remove(M.wordList_items[i], choice)
				--	-- Loop over the values in the range
				--	if start and finish ~= nil then
				--		for j = start, finish do
				--			print(j)
				--			table.remove(M.wordList_items[i], j)
				--		end
				--	else
				--		table.remove(M.wordList_items[i], choice)
				--	end

				updateWordlist(wordList, M.wordList_items[i], checkMultiple, 1)
				update.update_word_list()
			end
		else -- else will run this
			local choice = M.entry_remove[i].text
			if choice ~= "" then
				local start, finish = string.match(choice, "(%d+)-(%d+)")
				local start = tonumber(start)
				local finish = tonumber(finish)

				table.remove(M.wordList_items[i], choice)
				-- Loop over the values in the range
				--if start and finish ~= nil then
				--	for j = start, finish do
				--		print(j)
				--		table.remove(M.wordList_items[i], j)
				--	end
				--else
				--	table.remove(M.wordList_items[i], choice)
				--end

				updateWordlist(wordList, M.wordList_items[i], checkMultiple, 1)
				update.update_word_list()
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

return M
