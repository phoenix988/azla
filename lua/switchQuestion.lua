--{{ Module to create a function to switch question when you press on next
-- And when you reach the last question it will show the visibility of some hidden buttons
-- Also declaring some buttons in this module
--}}


-- Imports of Libaries
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local gio               = require("lgi").Gio
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")

-- Sets the import table
local import = {}

-- sets currentquestion
local currentQuestion = 1

-- function to import currentquestion
function import.setQuestion()
   currentQuestion = 1
end

-- Function so it switch question after you submit your answer
function import.switchQuestion(next,question, 
                               w,wg,bt)

     local theme = require("lua.theme.default")
     local font  = theme.font.load()
     local theme = theme.load()
     
     -- Imports active wordlist
     local mainWindowModule = require("lua.main")
     local getWordList = mainWindowModule.getWordList
     local wordlist = getWordList()
     local count = tonumber(wordlist.count)
     
     if next == true then
        currentQuestion = currentQuestion + 1
     elseif next == false then
        if currentQuestion ~= 1 then
           currentQuestion = currentQuestion - 1
        end  
     else 
        currentQuestion = next
     end
 
     local chosen_wordlist = #wordlist 
     
     -- Checks if the wordlist has less words than the count choice
     -- If true then it will change the value of count
     if chosen_wordlist < count then
         count = chosen_wordlist
     end

     if currentQuestion > count then
        wg.labelEnd:set_visible(true)
        wg.labelEnd:set_text("You reached the last question")
        wg.labelEnd:set_markup("<span foreground='" .. theme.label_fg .. "'size='" .. font.welcome_size .. "'>" .. wg.labelEnd.label .. "</span>")
        bt.again.restart:set_visible(true)
        wg.labelEndCorrect:set_markup("<span foreground='" .. theme.label_correct .. "'>Correct: " .. question.correct .. "</span>")
        wg.labelEndIncorrect:set_markup("<span foreground='" .. theme.label_incorrect .. "'>Incorrect: " .. question.incorrect .. "</span>")
        bt.sum.summary:set_visible(true)
        bt.last.back:set_margin_top(30)
        wg.tree:set_visible(false)

     end

     -- Hide all question elements
     --for i = 1, #wordlist do
     for i = 1, math.min(#wordlist, count) do
        w.question_labels[i]:set_visible(false)
        w.entry_fields[i]:set_visible(false)
        w.submit_buttons[i]:set_visible(false)
        w.result_labels[i]:set_visible(false)
        w.next_buttons[i]:set_visible(false)
        w.current_labels[i]:set_visible(false)
     end
  

     -- Show the active question elements
     if w.question_labels[currentQuestion] ~= nil then 
       w.question_labels[currentQuestion]:set_visible(true)
     end
     
     if w.entry_fields[currentQuestion] ~= nil then 
       w.entry_fields[currentQuestion]:set_visible(true)
     end

     if w.submit_buttons[currentQuestion] ~= nil then 
       w.submit_buttons[currentQuestion]:set_visible(true)
     end

     if w.result_labels[currentQuestion] ~= nil then 
       local mode = require("lua.main").getWordList()
       if mode.mode == false then
          w.result_labels[currentQuestion]:set_visible(true)
       end
     end

     if w.next_buttons[currentQuestion] ~= nil then 
       if next == false or type(next) == "number" then
          w.next_buttons[currentQuestion]:set_visible(true)
       else
          w.next_buttons[currentQuestion]:set_visible(false)
       end
     end

     if w.current_labels[currentQuestion] ~= nil then 
       w.current_labels[currentQuestion]:set_visible(false)
     end

     -- Return currentquestion variable
     return currentQuestion
end


-- Returns the functions
return import
