-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local Gdk = require("lgi").Gdk
local GLib = require("lgi").GLib
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require("GdkPixbuf")
local lfs = require("lfs")
local os = require("os")

-- Import widgets
local widget = require("lua.widgets.box")
local notebook = require("lua.widgets.notebook")
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

-- Function to update the wordlist file with new entries
local function updateWordlist(wordlist, words)
	-- Import the chosen wordlist
	local formatList = require(var.wordMod .. "." .. wordlist)

	-- Loop through the new list to add
	for i = 1, #words do
		-- Gets the diffrent words
		local azerbaijani = words[i][1]
		local english = words[i][2]

		-- Add the new entry to the wordlist
		table.insert(formatList, { azerbaijani, english })
	end

	-- Create custom word path if it doesn't exist
	if not fileExists(var.wordDir_alt) then
		mkdir(var.wordDir_alt)
	end

	-- Serialize the updated wordlist and write it back to the file
	local file = io.open(var.wordDir_alt .. "/" .. wordlist .. ".lua", "w")
	file:write("local = wordlist {\n")
	for _, entry in ipairs(formatList) do
		file:write(string.format('\t{ "%s", "%s" },\n', entry[1], entry[2]))
	end
	file:write("}\n\nreturn wordlist")
	file:close()

	print("Wordlist updated successfully!")
end

-- Creating empty tables
local M = {}
M.notebook = {}
M.box = {}
M.wordList_items = {}
M.grid_main = {}
M.grid_items = {}
M.grid = {}
M.entry_items = {}
M.import_items = {}
M.new_list = {}
M.label_list = {}

-- Calls the getluafilesdirectory function
local directoryPath = var.wordDir
local luaFiles = list.dir(directoryPath)

-- Create popover
M.popover = Gtk.Popover({
	relative_to = window,
})

-- Create menubar
M.menuBar = Gtk.MenuButton({ label = "File", popover = M.popover })

-- Create a label to display the selected menu item
M.label = Gtk.Label({ label = "No menu item selected" })

-- Create a notebook for the wordlist
M.notebook.word = Gtk.Notebook.new()
M.notebook.word:set_tab_pos(Gtk.PositionType.LEFT)

-- Create a scrolled window
local scrolledWindow = Gtk.ScrolledWindow({
	hscrollbar_policy = Gtk.PolicyType.NEVER,
	vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
	min_content_width = 1, -- Minimum width of the scrolled window
	min_content_height = 500,
})

-- Add notebook widget to the scrolled window
scrolledWindow:set_child(M.notebook.word)

-- Append the scroll window
widget.box_word_list:append(scrolledWindow)

for i, item_label in ipairs(luaFiles) do
	local wordList = list.modify(item_label)

	-- Create box widget for all items
	M.box[i] = Gtk.Box({
		orientation = Gtk.Orientation.VERTICAL,
		spacing = 5,
		halign = Gtk.Align.CENTER,
		valign = Gtk.Align.START,
		hexpand = false,
		vexpand = false,
	})

	-- creates widgets notebook and grid widgets for all the words
	M.notebook.word:append_page(M.box[i], Gtk.Label({ label = wordList }))
	M.grid_items[i] = widget.grid:main_create()
	M.grid_main[i] = widget.grid:main_create()

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

	-- Import the wordlist
	M.wordList_items[i] = require(var.wordMod .. "." .. wordList)

	-- Create grid widget for buttons
	M.grid[i] = widget.grid:main_create()
	M.grid[i]:set_hexpand(true)

	-- Create empty table for entry widgets
	M.entry_items.azerbajaniEntry = {}
	M.entry_items.englishEntry = {}

	-- Sets the first entry boxes to add a new word
	local entry_az = Gtk.Entry({ margin_top = 50, placeholder_text = "Azerbajani Word" })
	local entry_eng = Gtk.Entry({ margin_top = 50, placeholder_text = "English Word" })

	-- Create submit and add button for the grid
	local submit = Gtk.Button({ label = "Submit" })
	local addAnother = Gtk.Button({ margin_top = 50, label = "Add" })

	-- Make all dirs to lowercase
	local lower = wordList:lower()

	-- Make sure you dont get errors
	local success, result = pcall(function()
		SubDir = list.dir(directoryPath .. "/" .. lower)
	end)

	-- If pcall succedd this will run
	if success then
		M.import_items[wordList] = {}
		M.new_list[wordList] = {}
		for k = 1, #SubDir do
			local last = list.modify(SubDir[k])
			local allWords = lower .. "/" .. last
			local import = require(var.wordMod .. "." .. allWords)
			table.insert(M.import_items[wordList], import)

			for key, value in ipairs(import) do
				for j = 1, #value do
					table.insert(M.new_list[wordList], value[j])
				end
			end
		end
	end

	-- Attach widgets to the button grid
	M.grid[i]:attach(entry_az, 1, 0, 1, 1)
	M.grid[i]:attach(entry_eng, 2, 0, 1, 1)
	M.grid[i]:attach(addAnother, 3, 0, 1, 1)
	M.grid[i]:attach(submit, 0, 1, 4, 1)
	submit:set_margin_top(0)

	-- Attach the child grids
	M.grid_main[i]:attach(M.grid[i], 1, 2, 6, 1) -- attach grid for button
	M.grid_main[i]:attach(M.grid_items[i], 1, 1, 1, 1) -- attach grid for words
	--M.box[i]:append(M.grid[i])
	--M.box[i]:append(submit)

	-- Sets count to 0 at first
	local entryCount = 0
	local entryCounter = 0
	local firstRun = true

	-- Create table to store the buttons
	local button_table = {}
	local entry_table = {}
	local count_table = {}

	-- Function for add button
	local function add_button_action()
		-- Keep track of how many you add
		entryCount = entryCount + 1
		-- Will create new button for everytime you add a new word
		button_table[entryCount] = Gtk.Button({ label = "Add" })
		entry_table[entryCount] = Gtk.Button({ margin_top = 50, label = "X" })

		local add = button_table[entryCount]
		local remove = entry_table[entryCount]

		M.entry_items.azerbajaniEntry[entryCount] = Gtk.Entry({ placeholder_text = "Azerbajani Word" })
		M.entry_items.englishEntry[entryCount] = Gtk.Entry({ placeholder_text = "English Word" })
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
			-- Function for temove entry section
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
		updateWordlist(wordList, combTable)

		update.update_word_list()
	end

	local function isEven(number)
		return number % 2 == 0
	end

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

			label:set_size_request(100, -1)

			M.label_list[wordList][j] = label

			M.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)
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

return M
