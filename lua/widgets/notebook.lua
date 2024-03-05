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
   notebook.wordlist = Gtk.Notebook.new()

   -- Set notebook tab location
   notebook.theme:set_tab_pos(Gtk.PositionType.LEFT)
   notebook.setting:set_tab_pos(Gtk.PositionType.LEFT)

   -- Add tabs to the notebook
   notebook.theme:append_page(widget.box_theme_alt, Gtk.Label({ label = "Font" }))
   notebook.theme:append_page(widget.box_setting, Gtk.Label({ label = "Window" }))
   notebook.theme:append_page(widget.box_theme, Gtk.Label({ label = "Colors" }))
   notebook.wordlist:append_page(widget.box_word_list, Gtk.Label({ label = "Words" }))

   --widget.box_word_list:append(notebook.setting)
   --notebook.setting:append_page(widget.box_word_list_2, Gtk.Label({ label = "Test 1" }))
   --notebook.setting:append_page(widget.box_word_list_3, Gtk.Label({ label = "Test 2" }))

end

-- Create a stackswitcher
--      notebook.stackSwitcher = Gtk.StackSwitcher({ stack = stack_list_stack[i] })
--notebook.stack = Gtk.Stack()

--widget.box_word_list:append(notebook.stackSwitcher)

function notebook:create_main()
   -- Create the widget
   local widget = Gtk.Notebook.new()
   widget:set_tab_pos(Gtk.PositionType.LEFT)

   return widget
end

return notebook
