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
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
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
        width_request  = 100,
        height_request = 50,
        halign = Gtk.Align.FILL,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_start  = 40,
        margin_end    = 40
    })

    -- Makes third box 
    widget.box_third = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 40,
        margin_bottom = 40,
        margin_start  = 40,
        margin_end    = 40
    })
 

   -- Makes theme main box
    widget.box_theme_main = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 40,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 20,
        margin_bottom = 20,
        margin_start  = 20,
        margin_end    = 20
    })


    -- Makes theme box
    widget.box_theme = Gtk.Box({
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 5,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 20,
        margin_bottom = 20,
        margin_start  = 10,
        margin_end    = 10
    })

    -- Makes secondary theme box
    widget.box_theme_alt = Gtk.Box({
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 5,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 20,
        margin_bottom = 20,
        margin_start  = 10,
        margin_end    = 10
    })

    -- Makes theme box
    widget.box_setting = Gtk.Box({
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 5,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 20,
        margin_bottom = 20,
        margin_start  = 10,
        margin_end    = 10
    })


    widget.box_theme_button = Gtk.Box({
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 5,
        width_request  = 100,
        height_request = 50,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.FILL,
        hexpand = true,
        vexpand = true,
        margin_top    = 0,
        margin_bottom = 0,
        margin_start  = 20,
        margin_end    = 20
    })

    widget.box_theme_label = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 5,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 0,
        margin_bottom = 0,
        margin_start  = 20,
        margin_end    = 20
    })


return widget
