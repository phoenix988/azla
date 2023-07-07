-- Imports libaries we need
local lgi         = require("lgi")
local Gtk         = lgi.require("Gtk", "4.0")
local GObject     = lgi.require("GObject", "2.0")
local GdkPixbuf   = lgi.require('GdkPixbuf')
local lfs         = require("lfs")
local os          = require("os")
local theme       = require("lua.theme.default")
local style       = require("lua.widgets.setting")
local label       = require("lua.widgets.label")
local fileExists  = require("lua.fileExist").fileExists
local mkdir       = require("lua.terminal.mkdir").mkdir
local question    = require("lua.question.main")

-- Load the theme
local theme       = theme.load()

-- Import Variables
local var         = require("lua.config.init")

-- import some functions related to buttons
local button      = require("lua.widgets.button.functions")

-- Sets config paths
local confPath    = var.customConfig
local confDir     = var.confDir

-- Create the start button
button.start = Gtk.Button({label = "Start", width_request = 100, margin_top = 20})
button.start = style.set_theme(button.start)

-- Button to start exam mode
button.exam_mode = Gtk.Button({label = "Exam Mode", width_request = 100, margin_bottom = 20})
button.exam_mode = style.set_theme(button.exam_mode)

-- Create the Exit button
button.exit = Gtk.Button({label = "Exit" })
button.exit = style.set_theme(button.exit)
button.exit_alt = Gtk.Button({label = "Exit", margin_top = 8})
button.exit_alt = style.set_theme(button.exit_alt)

-- Create some setting buttons
button.setting = Gtk.Button ({label = "Settings", margin_bottom = 20})
button.setting = style.set_theme(button.setting)

-- Create setting back button
button.setting_back = Gtk.Button ({label = "Back", margin_top = 8})
button.setting_back = style.set_theme(button.setting_back)

-- Create setting submit button
button.setting_submit = Gtk.Button ({label = "Apply", margin_top = 8, width_request = 200})
button.setting_submit = style.set_theme(button.setting_submit)

-- Create color scheme button
button.color_scheme = Gtk.Button ({label = "Set ColorScheme", margin_start = 1, width_request = 10,
                                   margin_bottom = 100,margin_top = 5,height_request = 1})
button.color_scheme = style.set_theme(button.color_scheme)

-- Makes result button to show your result
button.result = Gtk.Button({label = "Show Result", visible = true})

-- Function to create restore default button
function button.reset_create()
    local widget = Gtk.Button ({label = "Restore Default", margin_top = 20})
    local widget = style.set_theme(widget,{{color = "#ffffff", border_color = "#ffffff",
    size = 16}})

    return widget
end

-- Return the table
return button
    

