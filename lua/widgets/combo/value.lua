local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local os = require("os")
local GObject = lgi.require("GObject", "2.0")
local theme = require("lua.theme.default")
local label = require("lua.widgets.label")

local widget = {}

-- Set default label for combo box
function widget:set_default_label()
   local set = {}
   set.wordActive = combo.word:get_active()
   local labelWordStringStart = combo.word_files[set.wordActive + 1]
   local last = string.match(labelWordStringStart, "[^/]+$")
   set.last_word_label = string.match(last, "([^.]+).")

   return set
end

-- Function to set value of combo boxes on startup
function widget:set_value(combo_set, value)
   local config = self.app.config
   local custom = self.app.custom
   local fileExist = self.app.fileExist

   if config == nil then
      combo_set:set_active(1)
   else
      if fileExist(custom) then
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

-- Define a method to set label_count
function widget:set_count()
   -- Imports Config function that will load config files
   local loadConfig = require("lua.loadConfig").load_config

   -- Imports filexist module
   local fileExist = require("lua.fileExist").fileExists

   -- Import variables
   local var = require("lua.config.init")
   -- sets first start variable
   local isFirstStart = true

   -- Gets the length of the wordlist
   self.app.choice = self.app.modelWord[self.app.activeWord][1]

   -- Check if custom path exist 
   local wordDir_alt = var.wordDir_alt .. "/" .. self.app.choice .. ".lua"

   -- If the custom path exist it will load it instead 
   if fileExists(wordDir_alt) then
      self.app.wordlist = loadConfig(wordDir_alt)
   else
      self.app.wordlist = require(self.app.module .. "." .. self.app.choice)
   end

   -- Counts the amount of words a list have
   local wordlist = self.app.wordlist
   self.app.list_count = #wordlist

   -- Create new empty table to use
   self.app.list_new = {}

   -- The table count
   local wordlist = self.app.list_count
   local list_new = self.app.list_new

   -- If the wordlist contain more than 40 words then this will limit the choice to 40
   if self.app.list_count >= 40 then
      self.app.list_count = 40
   end

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

      if isFirstStart then
         isFirstStart = false
         if self.app.word_count_set ~= nil then
            combo.word_count:set_active(self.app.word_count_set)
         end
      else
         combo.word_count:set_active(3)
      end
   end
end

function widget:set_count_value()
   -- Imports Config function that will load config files
   local loadConfig = require("lua.loadConfig").load_config

   -- Imports filexist module
   local fileExist = require("lua.fileExist").fileExists

   -- Import variables
   local var = require("lua.config.init")

   self.app.choice = self.app.modelWord[self.app.activeWord][1]
   local wordDir_alt = var.wordDir_alt .. "/" .. self.app.choice .. ".lua"

   if fileExists(wordDir_alt) then
      self.app.wordlist = loadConfig(wordDir_alt)
   else
      self.app.wordlist = require(self.app.module .. "." .. self.app.choice)
   end

   local wordlist = self.app.wordlist
   self.app.list_count = #wordlist
   self.app.list_new = {}

   local wordlist = self.app.list_count
   local list_new = self.app.list_new

   -- If the wordlist contain more than 40 words then this will limit the choice to 40
   if wordlist >= 40 then
      wordlist = 40
   end

   -- Gets the length of the wordlist file on startup
   for i = 1, wordlist do
      if i % 2 == 0 then -- Check if the index is even (every second number)
         table.insert(list_new, i)
      end
   end

   -- Clears the model if it doesn't exist
   combo.word_model:clear()
   combo.word_count_items = {}
   for i = 1, #list_new do
      combo.word_count_items[i] = list_new[i]
      combo.word_model:append({ combo.word_count_items[i] })
   end

   return input
end

return widget
