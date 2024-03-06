-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local theme = require("lua.theme.default")
local style = require("lua.widgets.setting")
style.color = theme.load()
local font = theme.font.load()

-- import some functions related to buttons
local button = require("lua.widgets.button.functions")

-- Create the start button
button.start = Gtk.Button({ label = "Start", width_request = 100, margin_top = 20 })
button.start = style.set_theme(button.start)

-- Button to start exam mode
button.exam_mode = Gtk.Button({ label = "Exam Mode", width_request = 100 })
button.exam_mode = style.set_theme(button.exam_mode)

button.restore_mode = Gtk.Button({ label = "Restore Session", width_request = 100, margin_bottom = 20 })
button.restore_mode = style.set_theme(button.restore_mode)

-- Create the Exit button
button.exit = Gtk.Button({ label = "Exit" })
button.exit = style.set_theme(button.exit)
button.exit_alt = Gtk.Button({ label = "Exit", margin_top = 8 })
button.exit_alt = style.set_theme(button.exit_alt)

-- Create some setting buttons
button.setting = Gtk.Button({ label = "Settings"})

button.setting = style.set_theme(
	button.setting,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

-- Create setting back button
button.setting_back = Gtk.Button({ label = "Back", margin_top = 8 })
button.setting_back = style.set_theme(
	button.setting_back,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

-- Create setting submit button
button.setting_submit = Gtk.Button({ label = "Apply", margin_top = 8, width_request = 200 })
button.setting_submit = style.set_theme(
	button.setting_submit,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.setting_wordlist = Gtk.Button({ label = "Show WordLists", margin_top = 8, width_request = 200 })
button.setting_wordlist = style.set_theme(
	button.setting_wordlist,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.exit_alt = style.set_theme(
	button.exit_alt,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.exit = style.set_theme(
	button.exit,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.start = style.set_theme(
	button.start,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.exam_mode = style.set_theme(
	button.exam_mode,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

button.restore_mode = style.set_theme(
	button.restore_mode,
	{ { color = style.color.label_welcome, border_color = style.color.label_welcome, size = font.fg_size / 1000 } }
)

-- Create color scheme button
button.color_scheme = Gtk.Button({
	label = "Set ColorScheme",
	margin_start = 1,
	width_request = 10,
	margin_bottom = 100,
	margin_top = 5,
	height_request = 1,
})
-- Set the color scheme
button.color_scheme = style.set_theme(button.color_scheme)

-- Makes result button to show your result
button.result = Gtk.Button({ label = "Show Result", visible = true })

-- Function to create restore default button
function button.reset_create()
	local widget = Gtk.Button({ label = "Restore Default", margin_top = 20 })
	local widget = style.set_theme(
		widget,
		{ { color = style.color.label_fg, border_color = style.color.label_fg, size = font.welcome_size / 1000 } }
	)

	return widget
end

-- Return the table
return button
