local widget = require("lua.widgets.init")
local json = require("lua.question.save")

-- Imports Config function that will load config files
local loadConfig = require("lua.loadConfig").load_config
local list = require("lua.terminal.listFiles")

-- Imports filexist module
local fileExist = require("lua.fileExist").fileExists

-- Import variables
local var = require("lua.config.init")

-- Create module
local M = {}

function M.start_azla(exam, win, window, create_app2, luaWordsModule)
   local activeWord = widget.combo.word:get_active()
   local activeWordCount = widget.combo.word_count:get_active()

   -- Wont throw an error if count is empty
   local success = pcall(function()
      choice = widget.combo.word_list_model[activeWord][1]
      choice_count = widget.combo.word_model[activeWordCount][1]
   end)

   -- Sets alt path to the wordlist dir
   local wordDir_alt = var.wordDir_alt .. "/" .. choice .. ".lua"

   -- Use custom wordfile if it exist
   if fileExists(wordDir_alt) then
      local wordlist = loadConfig(wordDir_alt)
      Update = wordlist
   else -- Else it uses the default wordfile
      Update = require(luaWordsModule .. "." .. choice)
   end

   if combo.restore_list then
      local active_restore_list = combo.restore_list:get_active()

      -- Only get the list name
      newStr = combo.restore_files[active_restore_list + 1]

      if newStr then
         last = list.modify(newStr)
      end
   end

   -- Create the table with options to pass on to the main question file
   wordlist = Update
   wordlist.count = choice_count
   wordlist.name = choice
   wordlist.count_start = 1
   wordlist.words = false
   wordlist.check = {
      dontSave = false,
      file = last,
   }

   -- Sets exam mode to true or false
   if exam == true then
      wordlist.mode = true
   else
      wordlist.mode = false
   end

   -- Gets the window dimeonsions to return them later
   window.width = win:get_allocated_width()
   window.height = win:get_allocated_height()

   -- Hide main window
   win:hide()

   -- Starts the questions
   local app2 = create_app2()
   app2:run()
end

function M.load_session(exam, win, window, create_app2, luaWordsModule)
   -- Import json file
   local settings = json.loadSession()

   local success, result = pcall(function()
      -- Sets alt path to the wordlist dir
      local wordDir_alt = var.wordDir_alt .. "/" .. settings.wordlist .. ".lua"

      -- Use custom wordfile if it exist
      if fileExists(wordDir_alt) then
         local wordlist = loadConfig(wordDir_alt)
         Update = wordlist
      else
         Update = require(luaWordsModule .. "." .. settings.wordlist)
      end

      local active_restore_list = combo.restore_list:get_active()

      -- Only get the list name
      newStr = combo.restore_files[active_restore_list + 1]

      if newStr then
         last = list.modify(newStr)
      end

      wordlist = Update
      wordlist.count = settings.count_last
      wordlist.name = settings.wordlist
      wordlist.count_start = settings.count_start

      wordlist.words = settings.word
      wordlist.entry = settings.entry
      wordlist.correct = settings.correct
      wordlist.incorrect = settings.incorrect
      wordlist.lang = settings.lang
      wordlist.checkForMultiple = settings.treeViewCheck
      wordlist.check = {
         dontSave = true,
         file = last,
      }

      local exam = settings.exam_mode or exam

      if exam == true then
         wordlist.mode = true
      else
         wordlist.mode = false
      end

      -- Gets the window dimeonsions to return them later
      window.width = win:get_allocated_width()
      window.height = win:get_allocated_height()

      -- Starts the questions
      win:hide()

      local app2 = create_app2()
      app2:run()
   end)

   if not success then
      print("No session to load")
   end
end

return M
