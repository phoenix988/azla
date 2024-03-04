local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local style = require("lua.widgets.setting")

local M = {}

-- Defines the function
function M.first_question()
	local mainModule = require("lua.main")
	local getDim = mainModule.getWindowDim
	local window = getDim()

	-- Gets the posistion of the main window
	--local windowX, windowY = getCenterPosition(window.main)

	local dialog = Gtk.MessageDialog({
		message_type = Gtk.MessageType.INFO,
		buttons = Gtk.ButtonsType.OK,
		text = "Already at the first question",
	})

	dialog.on_response = function(dialog, response_id)
		if response_id == Gtk.ResponseType.OK then
			dialog:close() -- Close the dialog
		end
	end

	-- Calculate the center position of the dialog box
	--local dialogX, dialogY = getCenterPosition(dialog)

	-- Move the dialog box to the new position
	dialog:set_transient_for(window.main)

	dialog:show()
end

local function buttonYesAction(currentQuestion, switchQuestion, question, prevButton, submitButton, w, wg, bt)
	-- Move to the next question
	currentQuestion = switchQuestion(true, question, w, wg, bt)

	if currentQuestion > question.last then
		prevButton:set_visible(false)
		submitButton:set_visible(false)
	end

	return currentQuestion
end

-- Pop up window to prompt for confirmation
function M.are_you_sure(
	currentQuestion,
	switchQuestion,
	question,
	prevButton,
	submitButton,
	w,
	wg,
	bt,
	theme,
	font,
	list,
	replace,
	response,
	mainWordList
)
	-- Create the main application
	local app = Gtk.Application()

	-- Connect to the "activate" signal to handle application startup
	function app:on_activate()
		-- Create a Gtk window
		local window = Gtk.Window({
			title = "Confirmation",
			default_width = 350,
			default_height = 130,
			resizable = false,
			on_destroy = Gtk.main_quit,
		})

		-- Create a Gtk box container
		local box = Gtk.Box({
			orientation = Gtk.Orientation.VERTICAL,
		})

		-- Create a label with the prompt message
		if question.complete then
			M.label = Gtk.Label({
				label = "You Are done,\n Are you sure you want to continue ?",
				margin_top = 8,
				margin_bottom = 20,
			})

		else
			M.label = Gtk.Label({
				label = "You didn't answer all questions,\n Are you sure you want to continue ?",
				margin_top = 8,
				margin_bottom = 20,
			})

		end

		style.set_theme(
			M.label,
			{ { color = theme.label_fg, border_color = theme.label_fg, size = font.fg_size / 1000 } }
		)

		-- Add the label to the box container
		box:append(M.label)

		-- Create a Gtk button box
		local buttonBox = Gtk.Box({
			orientation = Gtk.Orientation.HORIZONTAL,
			halign = Gtk.Align.CENTER,
			spacing = 10,
		})

		-- Create a Gtk button for "Yes"
		local buttonYes = Gtk.Button({
			label = "Yes",
			margin_end = 10,
		})

		-- Connect to the "clicked" signal for "Yes" button
		function buttonYes:on_clicked()
			print("User confirmed.")

			qurrentQuestion =
				buttonYesAction(currentQuestion, switchQuestion, question, prevButton, submitButton, w, wg, bt)

			-- Close the window
			window:close()
		end

		-- Create a Gtk button for "No"
		local buttonNo = Gtk.Button({
			label = "No",
			margin_start = 10,
		})

		-- Connect to the "clicked" signal for "No" button
		function buttonNo:on_clicked()
			-- Close the window
			window:close()

			M.confirm = false
		end

		-- Add the buttons to the button box
		buttonBox:append(buttonYes)
		buttonBox:append(buttonNo)

		-- Add the button box to the box container
		box:append(buttonBox)

		-- Set the box container as the window's child
		window.child = box

		-- Show all widgets
		window:present()
	end

	-- Run the application
	app:run()

	return M
end

-- Returns all avriables we need to import
return M
