local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local style = require("lua.widgets.setting")
local var = require("lua.config.init")

local M = {}

-- Pop up window to prompt for confirmation
function M.new_word_list(name_wordlist)
	-- Create the main application
	local app = Gtk.Application()

	-- Connect to the "activate" signal to handle application startup
	function app:on_activate()
		-- Create a Gtk window
		local window = Gtk.Window({
			title = "New Wordlist",
			default_width = 750,
			default_height = 400,
			resizable = false,
			on_destroy = Gtk.main_quit,
		})

		-- Create a Gtk box container
		local box = Gtk.Box({
			orientation = Gtk.Orientation.VERTICAL,
		})
		-- Create a text buffer
		local buffer = Gtk.TextBuffer()

		-- Create a text view widget
		local text_view = Gtk.TextView({
			buffer = buffer,
			wrap_mode = "WORD",
			hexpand = true,
			vexpand = true,
		})

		-- Create a scrolled window to contain the text view
		local scrolled_window = Gtk.ScrolledWindow({
			hscrollbar_policy = "NEVER",
			vscrollbar_policy = "AUTOMATIC",
			text_view,
		})

		-- Create a function to extract values from the text
		local function extract_values(text)
			local values = {}
			for value in string.gmatch(text, "[^,\n]+") do
				table.insert(values, value)
			end
			return values
		end

		local function isEven(number)
			return number % 2 == 0
		end

		local save_button = Gtk.Button({
			label = "Save",
			on_clicked = function()
				local start_iter, end_iter = buffer:get_bounds()
				local text = buffer:get_text(start_iter, end_iter, true)
				local values = extract_values(text)
				local wordlist_table = {}
				local aze_table = {}
				local en_table = {}
				for i = 1, #values do
					if not isEven(i) then
						table.insert(aze_table, values[i])
					else
						table.insert(en_table, values[i])
					end
				end
				for i = 1, #values do
					table.insert(wordlist_table, { aze_table[i], en_table[i] })
				end

				local file = io.open(var.wordDir_alt .. "/" .. name_wordlist .. ".lua", "w")
				if file then
					file:write("local wordlist = {\n")
					for _, entry in ipairs(wordlist_table) do
						if entry[1] ~= nil or entry[2] ~= nil then
							file:write(string.format('\t{ "%s", "%s" },\n', entry[1],
								entry[2]))
						end
					end
					file:write("}\n\nreturn wordlist")
					file:close()
				end

				window:destroy()
			end,
		})

		scrolled_window:set_child(box)

		box:append(text_view)
		box:append(save_button)

		-- Set the box container as the window's child
		window.child = scrolled_window

		-- Show all widgets
		window:present()
	end

	-- Run the application
	app:run()
end

return M
