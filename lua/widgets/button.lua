-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")

local button = {}

-- Create the start button
button.start = Gtk.Button({label = "Start", width_request = 100})

-- Create the Exit button
button.exit = Gtk.Button({label = "Exit", width_request = 30, })


return button
    

