-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GLib = require("lgi").GLib
local GObject = lgi.require("GObject", "2.0")
local style = require("lua.widgets.setting")
local theme = require("lua.theme.default")

local M = {}

-- List of color schemes
M.colorSchemes = {
   "Custom",
   "Default",
   "Dracula",
   "Iceberg",
   "Nord",
   "Tokyo_night",
   "Rose_pine",
}

-- Gets active colorscheme if its set
if theme.scheme then
   for i, scheme in ipairs(M.colorSchemes) do
      if scheme == theme.scheme then
         defaultIndex = i
         break
      end
   end
   -- Sets the value to custom if no scheme is set
else
   defaultIndex = 1
end

-- Fail switch if you choose a theme that doesn't exist
if defaultIndex == nil then
   defaultIndex = 1
end
-- Create a list box 
function M:create()
   local listBox = Gtk.ListBox()

   -- Create a list box row for each color scheme
   for _, scheme in ipairs(M.colorSchemes) do
      local row = Gtk.ListBoxRow()

      -- Create a label widget for the color scheme
      local label = Gtk.Label({ label = scheme })

      -- Add the label widget to the row
      row:set_child(label)

      -- Handle row selection
      row.on_activate = function()
         print("Selected scheme:", scheme)
      end

      -- Add the row to the list box
      listBox:append(row)
   end

   return listBox
end

-- Create treeView for available color schemes
function M:create_tree()
   local font = theme.font.load()
   local theme = theme.load()
   -- Create a tree view model
   M.listStore = Gtk.ListStore.new({ GObject.Type.STRING })

   for _, scheme in ipairs(M.colorSchemes) do
      M.listStore:append({ scheme })
   end

   -- Create a tree view
   local treeView = Gtk.TreeView({
      model = M.listStore,
      margin_bottom = 5,
   })

   local renderer = Gtk.CellRendererText()
   local column = Gtk.TreeViewColumn({ title = "Color Schemes" })

   local treeView = style.set_theme(
      treeView,
      { { size = font.fg_size / 1000, color = theme.label_word, border_color = theme.label_fg } }
   )

   column:pack_start(renderer, true)
   --column:add_attribute(renderer, "text", 1)
   column:add_attribute(renderer, "text", 0)
   treeView:append_column(column)

   -- Get the tree selection and set the default selection
   local selection = treeView:get_selection()
   local model = treeView:get_model()
   local iter = model:get_iter_from_string(tostring(defaultIndex - 1)) -- Select the first row
   selection:select_iter(iter)

   M.tree = treeView
   M.column = column

   -- Update the theme when you change selection
   selection.on_changed:connect(function()
      local update = require("lua.theme.update")
      local write = require("lua.config.init")
      local theme = require("lua.theme.default")
      theme.color_scheme(M, write, update)
   end)

   return treeView
end

return M
