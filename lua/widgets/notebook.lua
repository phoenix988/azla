local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local widget = require("lua.widgets.box")
local button = require("lua.widgets.button")

-- Create notebook widgets
local notebook = {}

-- Create notebook widgets for the settings
function notebook:create()
   -- Create the notebook
   notebook.theme = Gtk.Notebook.new()
   notebook.setting = Gtk.Notebook.new()

   -- Set notebook tab location
   notebook.theme:set_tab_pos(Gtk.PositionType.LEFT)
   notebook.setting:set_tab_pos(Gtk.PositionType.LEFT)

   -- Add tabs to the notebook
   notebook.theme:append_page(widget.box_theme_alt, Gtk.Label({ label = "Font" }))
   notebook.theme:append_page(widget.box_setting, Gtk.Label({ label = "Window" }))
   notebook.theme:append_page(widget.box_theme, Gtk.Label({ label = "Colors" }))

   -- Create a stack widget
   -- notebook.stack = Gtk.Stack()

   -- appends widget to stack
   --notebook.stack:add_titled(button.setting_back, "stack", "Back")

   -- Create a stackswitcher
   --notebook.stackSwitcher = Gtk.StackSwitcher({ stack = notebook.stack })
end

function notebook:create_main()
   -- Create the widget
   local widget = Gtk.Notebook.new()
   widget:set_tab_pos(Gtk.PositionType.LEFT)

   return widget
end

return notebook
