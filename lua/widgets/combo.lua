local lgi     = require("lgi")
local Gtk     = lgi.require("Gtk", "4.0")
local os      = require("os")
local GObject = lgi.require("GObject", "2.0")
local theme   = require("lua.theme.default")
local label   = require("lua.widgets.label")

local writeToConfigModule  = require("lua.settings")
local writeTo_config       = writeToConfigModule.writeTo_config
local write                = writeToConfigModule.write

local home      = os.getenv("HOME")
local cacheFile = home .. "/.cache/azla.lua"
local replace   = {}
local combo     = {}


function combo.word_count_create()

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
function combo.lang_create()

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

-- Function to set value of combo boxes on startup
function combo.set_value(config,customConfig,combo_set,fileExist,value)

  if config == nil then
         combo_set:set_active(1)
      else
         if fileExist(customConfig) then
            if value == nil then
               if value == nil then
                 defaultWord = 0
               else
                 defaultWord = value
               end
  
            else
               defaultWord = value
            end
            combo_set:set_active(defaultWord)
         else 
            if value == nil then 
               combo_set:set_active(1)
            else  
               local defaultWord = value
               combo_set:set_active(defaultWord)
            end
         end
  end


end


return combo
