-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local style = require("lua.widgets.setting")
local theme = require("lua.theme.default")

local M = {}

-- Create treeView for available color schemes
function M:create_tree(word)
   local font = theme.font.load()
   local theme = theme.load()

   -- Create a tree view model
   M.listStore = Gtk.ListStore.new({ GObject.Type.STRING })

   for i = 1, #word do
      M.listStore:append({ word[i] })
   end

   -- Create a tree view
   local treeView = Gtk.TreeView({
      model = M.listStore,
      margin_bottom = 5,
   })

   local renderer = Gtk.CellRendererText()
   local column = Gtk.TreeViewColumn({ title = "Questions" })

   local treeView = style.set_theme(
      treeView,
      { { size = font.fg_size / 1000, color = theme.label_word, border_color = theme.label_fg } }
   )

   column:pack_start(renderer, true)
   column:add_attribute(renderer, "text", 0)
   treeView:append_column(column)

   M.tree = treeView
   M.column = column

   return treeView
end

return M
