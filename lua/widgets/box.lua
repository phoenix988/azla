-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")

local widget = {}

-- Makes the main box widget to be used 
     widget.box_main = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
    })
     
    -- Makes first box 
    widget.box_first = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
        width_request  = 200,
        height_request = 400,
        halign = Gtk.Align.FILL,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 40,
        margin_bottom = 40,
        margin_start  = 40,
        margin_end    = 40
    })
 
    -- Makes secondary box
    widget.box_second = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 0,
        width_request  = 50,
        height_request = 50,
        halign = Gtk.Align.FILL,
        valign = Gtk.Align.BOTTOM,
        hexpand = true,
        vexpand = true,
        margin_start  = 40,
        margin_end    = 40
    })

return widget

