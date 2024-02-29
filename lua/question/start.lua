local widget = require("lua.widgets.init")
local json = require("lua.question.save")

local M = {}

function M.start_azla(exam, win, window, create_app2, luaWordsModule)
   local activeWord = widget.combo.word:get_active()
   local activeWordCount = widget.combo.word_count:get_active()

   local choice = widget.combo.word_list_model[activeWord][1]
   local choice_count = widget.combo.word_model[activeWordCount][1]
   wordlist = require(luaWordsModule .. "." .. choice)
   wordlist.count = choice_count
   wordlist.name = choice
   wordlist.count_start = 1
   wordlist.words = false

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
end

function M.load_session(exam, win, window, create_app2, luaWordsModule)
   -- Import json file
   local settings = json.loadSession()

   local success, result = pcall(function()
      wordlist = require(luaWordsModule .. "." .. settings.wordlist)
      wordlist.count = settings.count_last
      wordlist.name = settings.wordlist
      wordlist.count_start = settings.count_start

      wordlist.words = settings.word
      wordlist.entry = settings.entry
      wordlist.correct = settings.correct
      wordlist.incorrect = settings.incorrect
      wordlist.lang = settings.lang

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
