local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")
local os      = require("os")
local GObject = lgi.require("GObject", "2.0")
local theme   = require("lua.theme.default")
local label   = require("lua.widgets.label")

local combo   = {}

-- Import some methods
local combo   = require("lua.widgets.combo.value")


-- Creates combo class
function combo:new(inp)
    local obj = {} -- Create a new instance
    obj.app   = inp -- Set instance-specific attributes
    setmetatable(obj, self) -- Set the metatable to allow accessing class methods
    self.__index = self -- Set the index to the class table
    return obj -- Return the instance
end

function combo:create_word_list()

    local list = self.app.list

    -- Model for the second combo box
    combo.word_list_model = Gtk.ListStore.new({ GObject.Type.STRING })
    
    -- Calls the getluafilesdirectory function
    local directoryPath = self.app.path
    local luaFiles = list.dir(directoryPath)
    combo.word_files = luaFiles

      -- Add items to the wordfile combo box
    for _, luafiles in ipairs(combo.word_files) do
        local add = list.modify(luafiles)
        combo.word_list_model:append({ add })
    end
    
    -- Makes the combobox widget for wordlists
    combo.word = Gtk.ComboBox({
        model = combo.word_list_model,
        active = 0,
        cells = {
          {
            Gtk.CellRendererText(),
            { text = 1 },
            align = Gtk.Align.START
          }
        }
    })


end

function combo:create_word_count()

    combo.word_model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Makes the combobox widgets
    combo.word_count = Gtk.ComboBox({
        model = combo.word_model,
        active = 0,
        cells = {
          {
            Gtk.CellRendererText(),
            { text = 1 },
            align = Gtk.Align.START
          }
        }
    })

end

-- Makes the combobox lang widget
function combo:create_lang()

    -- Define language options for language combo box
    combo.lang_items = {
      "Azerbaijan",
      "English"
    }

    combo.lang_model = Gtk.ListStore.new({ GObject.Type.STRING })

     -- Add the items to the language model
    for _, name in ipairs(combo.lang_items) do
        combo.lang_model:append({ name })
    end

    combo.lang = Gtk.ComboBox({
        model = combo.lang_model,
        active = 0,
        cells = {
          {
            Gtk.CellRendererText(),
            { text = 1 },
            align = Gtk.Align.START
          }
        }
    })
    

end


function combo:create_word_dir()
    
     local list = self.app.list

    -- Model for the second combo box
    combo.word_dir_model = Gtk.ListStore.new({ GObject.Type.STRING })
    
    -- Calls the getluafilesdirectory function
    local directoryPath = "lua/words_test"
    local luaFiles = list.dir(directoryPath, "dir")
    combo.word_dir_files = luaFiles

      -- Add items to the wordfile combo box
    for _, luafiles in ipairs(combo.word_dir_files) do
        local add = list.modify_dir(luafiles)
        combo.word_dir_model:append({ add })
    end
    
    -- Makes the combobox widget for wordlists
    combo.word_dir = Gtk.ComboBox({
        model = combo.word_dir_model,
        active = 0,
        cells = {
          {
            Gtk.CellRendererText(),
            { text = 1 },
            align = Gtk.Align.START
          }
        }
    })

    return combo.word_dir

end


return combo
