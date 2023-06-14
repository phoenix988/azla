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
function import.switchQuestion(correct_answers, incorrect_answers, 
                               w,wg,restartButton,
                               summaryButton,backButton)

     -- Imports active wordlist
     local mainWindowModule = require("lua.main")
     local getWordList = mainWindowModule.getWordList
     local wordlist = getWordList()
     local count = tonumber(wordlist.count)

     currentQuestion = currentQuestion + 1
     local chosen_wordlist = #wordlist 
     
     -- Checks if the wordlist has less words than the count choice
     -- If true then it will change the value of count
     if chosen_wordlist < count then
         count = chosen_wordlist
     end

     if currentQuestion > count then
        wg.labelEnd.label = "You reached the last question"
        wg.labelEnd:set_markup("<span foreground='" .. theme.label_fg .. "'>" .. wg.labelEnd.label .. "</span>")
        restartButton:set_visible(true)
        wg.labelEndCorrect.label = "correct: " .. correct_answers
        wg.labelEndCorrect:set_markup("<span foreground='" .. theme.label_correct .. "'>" .. wg.labelEndCorrect.label .. "</span>")
        wg.labelEndIncorrect.label = "Incorrect: " .. incorrect_answers
        wg.labelEndIncorrect:set_markup("<span foreground='" .. theme.label_incorrect .. "'>" .. wg.labelEndIncorrect.label .. "</span>")
        summaryButton:set_visible(true)
        backButton:set_margin_top(30)

     end

     -- Hide all question elements
     --for i = 1, #wordlist do
     for i = 1, math.min(#wordlist, count) do
        w.question_labels[i]:set_visible(false)
        w.entry_fields[i]:set_visible(false)
        w.submit_buttons[i]:set_visible(false)
        w.result_labels[i]:set_visible(false)
        w.next_buttons[i]:set_visible(false)
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
       w.result_labels[currentQuestion]:set_visible(true)
     end

     if w.next_buttons[currentQuestion] ~= nil then 
       w.next_buttons[currentQuestion]:set_visible(false)
     end

     -- Return currentquestion variable
     return currentQuestion
end


-- Returns the functions
return import
