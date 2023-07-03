-- Imports libaries we need
local lgi                  = require("lgi")
local Gtk                  = lgi.require("Gtk", "4.0")
local GObject              = lgi.require("GObject", "2.0")
local GdkPixbuf            = lgi.require('GdkPixbuf')
local lfs                  = require("lfs")
local os                   = require("os")

local M = {}




M.popover = Gtk.Popover {
   relative_to = window,
}


M.menuBar = Gtk.MenuButton {label = "File", popover = M.popover}


-- Create a label to display the selected menu item
M.label = Gtk.Label { label = "No menu item selected" }

-- Connect the "activate" signal of the menu items to a callback function
--M.newItem.on_activate = function()
--   label.label = "New menu item selected"
--end
--
--M.openItem.on_activate = function()
--   label.label = "Open menu item selected"
--end
--
--M.saveItem.on_activate = function()
--   label.label = "Save menu item selected"
--end
--
--function M.exitItem:on_activate()
--      print("exit")
--end

return M

