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


function combo.word_create(list,luaWordsPath)

    -- Model for the second combo box
    combo.word_list_model = Gtk.ListStore.new({ GObject.Type.STRING })
    
    -- Calls the getluafilesdirectory function
    local directoryPath = luaWordsPath
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

function combo.set_default_label(combo)
 
   local set = {}
   set.wordActive = combo.word:get_active()
   local labelWordStringStart = combo.word_files[set.wordActive + 1]
   local last = string.match(labelWordStringStart, "[^/]+$")
   set.last_word_label = string.match(last, "([^.]+).")
    
   return set 

end

function combo.count_set_label(input,combo)
    
    -- Gets the length of the wordlist
    input.choice               = input.modelWord[input.comboWord][1]
    input.wordlist_first       = require(input.luaWordsModule .. "." .. input.choice)
    local wordlist_first       = input.wordlist_first
    input.wordlist_count_f     = #wordlist_first
    input.wordlist_count_f_new = {}

    local wordlist_count_f     = input.wordlist_count_f 
    local wordlist_count_f_new = input.wordlist_count_f_new

    -- Gets the length of the wordlist file on startup
    for i = 1, wordlist_count_f do
          if i % 2 == 0 then -- Check if the index is even (every second number)
            table.insert(wordlist_count_f_new, i)
          end
    end
    
    -- Clears the model if it doesn't exist
    combo.word_model:clear()
    combo.word_count_items = {}
    for i = 1, #wordlist_count_f_new do
          combo.word_count_items[i] = wordlist_count_f_new[i]
          combo.word_model:append({ combo.word_count_items[i] })
    end

    return input

end


function combo:new(inp)
    local obj = {} -- Create a new instance
    obj.app   = inp -- Set instance-specific attributes
    setmetatable(obj, self) -- Set the metatable to allow accessing class methods
    self.__index = self -- Set the index to the class table
    return obj -- Return the instance
end


-- Define a method to set label_count
function combo:set_label_count()
        -- Gets the length of the wordlist
        self.app.choice             = self.app.modelWord[self.app.activeWord][1]
        self.app.wordlist           = require(self.app.module .. "." .. self.app.choice)

        local wordlist              = self.app.wordlist
        self.app.list_count         = #wordlist
        self.app.list_new           = {}

        local wordlist = self.app.list_count
        local list_new = self.app.list_new
        
        -- Counts the length of the wordlist
        -- And appends the number to the combo word count widget
        if combo.word_model ~= nil then
          combo.word_model:clear()
          combo.word_count_items = {}
          if wordlist >= 5 then
            for i = 1, self.app.list_count do
              if i % 2 == 0 then -- Check if the index is even (every second number)
                table.insert(self.app.list_new, i)
              end
            end
            for i = 1, #list_new do
              combo.word_count_items[i] = self.app.list_new[i]
              combo.word_model:append({ combo.word_count_items[i] })
            end
          else
           for i = 1, self.app.list_count do
              combo.word_count_items[i] = i
              combo.word_model:append({ combo.word_count_items[i] })
            end
          end  

          if self.app.isFirstStart == true then         
              isFirstStart = false
              combo.word_count:set_active(self.app.config.word_count_set)
          else
              combo.word_count:set_active(3)
          end

        end
  
end


return combo
