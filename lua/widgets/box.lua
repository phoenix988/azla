-- Modules that will create multiple box widgtes to be used

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")

local settings = {
    valign = Gtk.Align.FILL,
    halign = Gtk.Align.START,
}

-- Declare the table
local widget = {}

-- {{{ Main Window Start

-- Makes the main box widget to be used
widget.box_main = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER,
})

-- Makes first box
widget.box_first = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    width_request = 200,
    height_request = 400,
    halign = Gtk.Align.FILL,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_top = 40,
    margin_bottom = 40,
    margin_start = 40,
    margin_end = 40,
})

-- Makes secondary box
widget.box_second = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 0,
    width_request = 100,
    height_request = 50,
    halign = Gtk.Align.FILL,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_start = 40,
    margin_end = 40,
})

-- Makes third box
widget.box_third = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_top = 40,
    margin_bottom = 40,
    margin_start = 40,
    margin_end = 40,
})

-- Makes theme main box
-- Used as parent for all theme/setting boxes
widget.box_theme_main = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 40,
    halign = Gtk.Align.FILL,
    valign = Gtk.Align.FILL,
    hexpand = false,
    vexpand = false,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 20,
    margin_end = 20,
})

-- Makes theme box
-- Used for the color section
-- Under settings in the notebook widget
widget.box_theme = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = settings.halign,
    valign = settings.valign,
    hexpand = false,
    vexpand = false,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

-- Makes secondary theme box
-- Used for the font section
-- Under settings in the notebook widget
widget.box_theme_alt = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = settings.halign,
    valign = settings.valign,
    hexpand = false,
    vexpand = false,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

-- Makes setting box
-- Used for the window section
-- Under settings in the notebook widget
widget.box_setting = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = settings.halign,
    valign = settings.valign,
    hexpand = false,
    vexpand = false,
    margin_top = 150,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

-- Makes theme box button
-- Used for the buttons visible under settings
widget.box_theme_button = Gtk.Box({
    orientation = Gtk.Orientation.HORIZONTAL,
    spacing = 5,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.FILL,
    hexpand = false,
    vexpand = false,
    margin_top = 0,
    margin_bottom = 0,
    margin_start = 100,
    margin_end = 100,
})

-- Make wordlist box
-- Used for the words sections
-- Under settings in the notebook settings
widget.box_word_list = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = Gtk.Align.START,
    valign = Gtk.Align.START,
    hexpand = false,
    vexpand = false,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

widget.box_word_list_2 = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

widget.box_word_list_3 = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_top = 20,
    margin_bottom = 20,
    margin_start = 10,
    margin_end = 10,
})

-- Make theme label box to store labels
-- Under settings, foor example the label that says settings
widget.box_theme_label = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 5,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER,
    hexpand = true,
    vexpand = true,
    margin_top = 0,
    margin_bottom = 0,
    margin_start = 20,
    margin_end = 20,
})
-- Main Window end }}}

-- Function to create a box widget
-- Mainly used for the question window
function widget.box_question_create(orientation, fill)
    -- Makes the main box widget to be used

    local orientation = orientation or Gtk.Orientation.VERTICAL
    local fill = fill or Gtk.Align.FILL

    local box = Gtk.Box({
        orientation = orientation,
        spacing = 10,
        halign = fill,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top = 0,
        margin_bottom = 0,
        margin_start = 0,
        margin_end = 0,
    })

    return box
end

-- Function to create checkbox widget
-- used for the fulloscreen checkmark
-- in the questioon window
function widget.checkbox_create(win)
    widget.checkbox_1 = Gtk.CheckButton({ label = "Fullscreen", valign = Gtk.Align.Center, margin_top = 50 })

    function widget.checkbox_1:on_toggled()
        if widget.checkbox_1.active then
            win:fullscreen()
        else
            win:unfullscreen()
        end
    end

    local checkbox = widget.checkbox_1

    return checkbox
end

-- return the widgets
local M = widget

return M
