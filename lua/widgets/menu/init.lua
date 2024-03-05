-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require("GdkPixbuf")
local lfs = require("lfs")
local os = require("os")

-- Import widgets
local widget = require("lua.widgets.box")
local notebook = require("lua.widgets.notebook")
widget.grid = require("lua.widgets.grid")
local list = require("lua.terminal.listFiles")
local var = require("lua.config.init")

-- Import theme
local theme = require("lua.theme.default").load()

-- Creating empty tables
local M = {}
M.notebook = {}
M.box = {}
M.wordList_items = {}
M.grid_items = {}
M.entry_items = {}

-- Calls the getluafilesdirectory function
local directoryPath = var.wordDir
local luaFiles = list.dir(directoryPath)

-- Create popover 
M.popover = Gtk.Popover({
   relative_to = window,
})

-- Create menubar
M.menuBar = Gtk.MenuButton({ label = "File", popover = M.popover })

-- Create a label to display the selected menu item
M.label = Gtk.Label({ label = "No menu item selected" })

-- Create a notebook for the wordlist
M.notebook.word = Gtk.Notebook.new()

widget.box_word_list:append(M.notebook.word)

for i, item_label in ipairs(luaFiles) do
   local wordList = list.modify(item_label)

   M.box[i] = Gtk.Box({
      orientation = Gtk.Orientation.VERTICAL,
      spacing = 5,
      halign = Gtk.Align.START,
      valign = Gtk.Align.START,
      hexpand = true,
      vexpand = true,
   })

   M.notebook.word:append_page(M.box[i], Gtk.Label({ label = wordList }))
   M.grid_items[i] = widget.grid:main_create()
   M.box[i]:append(M.grid_items[i])
   M.wordList_items[i] = require(var.wordMod .. "." .. wordList)

   local button = Gtk.Entry({ margin_top = 50, text = "New Word" })
   local submit = Gtk.Button({ label = "Submit" })

   M.box[i]:append(button)
   M.box[i]:append(submit)

   function submit:on_clicked()
      print(button.text:lower())
   end

   for j = 1, #M.wordList_items[i] do
      local english = list.to_upper(M.wordList_items[i][j][2])
      local aze = list.to_upper(M.wordList_items[i][j][1])
      local form = aze .. " : " .. english
      local row = math.floor((j - 1) / 3)
      local col = (j - 1) % 3
      local label = Gtk.Label({ label = form })
      M.grid_items[i]:attach(label, col, row * 2 + 1, 1, 1)
   end
end

---- Connect the "activate" signal of the menu items to a callback function
--function M.newItem:on_activate()
--   label.label = "New menu item selected"
--end
--
--M.openItem.on_activate = function()
--   M.label.label = "Open menu item selected"
--end
--
--M.saveItem.on_activate = function()
--   M.label.label = "Save menu item selected"
--end
--
--function M.exitItem:on_activate()
--      print("exit")
--end

return M
