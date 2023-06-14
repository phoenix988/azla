local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local widget            = require("lua.widgets.box")


local notebook = {}

-- Create the notebook
notebook.theme = Gtk.Notebook()
notebook.setting = Gtk.Notebook()

-- Set notebook tab location
notebook.theme:set_tab_pos(Gtk.PositionType.LEFT)
notebook.setting:set_tab_pos(Gtk.PositionType.LEFT)

-- Add tabs to the notebook
notebook.theme:append_page(widget.box_theme, Gtk.Label({ label = "Theme 1" }))
notebook.theme:append_page(widget.box_theme_alt, Gtk.Label({ label = "Theme 2" }))
notebook.setting:append_page(widget.box_setting, Gtk.Label({ label = "Settings" }))

-- Create a stack widget
notebook.stack = Gtk.Stack()

-- appends widget to stack
--stack:add_titled(button.setting_back, "stack", "Back")

-- Create a stackswitcher
notebook.stackSwitcher = Gtk.StackSwitcher({ stack = notebook.stack })
      
return notebook