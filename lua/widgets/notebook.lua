local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local widget = require("lua.widgets.box")

-- Create notebook widgets
local notebook = {}

-- Create notebook widgets for the settings menu
function notebook:create()
   -- Create the notebooks
   notebook.theme = Gtk.Notebook.new()
   -- Not in use
   notebook.setting = Gtk.Notebook.new()

   -- Set notebook tab location
   notebook.theme:set_tab_pos(Gtk.PositionType.LEFT)
   notebook.theme:set_size_request(200, 150)
   notebook.setting:set_tab_pos(Gtk.PositionType.LEFT)

   -- Add tabs to the notebook
   notebook.theme:append_page(widget.box_theme_alt, Gtk.Label({ label = "Font" }))
   notebook.theme:append_page(widget.box_setting, Gtk.Label({ label = "Window" }))
   notebook.theme:append_page(widget.box_theme, Gtk.Label({ label = "Colors" }))

   -- Create a stack widget
   notebook.stack = Gtk.Stack({ transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT })

   -- appends widget to stack
   notebook.stack:add_titled(notebook.theme, "stack", "Theme")
   notebook.stack:add_titled(notebook.wordlist, "stack1", "Word")

   -- Create a stackswitcher
   notebook.stackSwitcher = Gtk.StackSwitcher({ stack = notebook.stack })

   return notebook
end

-- For the wordlists
-- Adds it outside the function so I can easily import it in files where I need to refrence it
notebook.wordlist = Gtk.Notebook.new()

notebook.wordlist:append_page(widget.box_word_list, Gtk.Label({ label = "Words" }))
notebook.wordlist:append_page(widget.box_word_list_2, Gtk.Label({ label = "Remove Files" }))

-- Simple example of how to add stack widget with a stack switcher
-- Create a stackswitcher
-- notebook.stack = Gtk.Stack()
-- notebook.stackSwitcher = Gtk.StackSwitcher({ stack = stack_list_stack[i] })
-- notebook.stack:add_titled(notebook.wordlist, "stack1", "Word")
-- widget.box_word_list:append(notebook.stackSwitcher)

-- Create simple notebook
function notebook:create_main()
   -- Create the widget
   local widget = Gtk.Notebook.new()
   widget:set_tab_pos(Gtk.PositionType.LEFT)

   return widget
end

-- Returns the functions and widgets
return notebook
