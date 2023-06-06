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
                               question_labels,entry_fields,submit_buttons,
                               result_labels,next_buttons,
                               labelEnd,labelEndCorrect,
                               labelEndIncorrect,restartButton,
                               summaryButton,backButton)

     -- Imports active wordlist
     local mainWindowModule = require("lua.mainWindow")
     local getWordList = mainWindowModule.getWordList
     local wordlist = getWordList()

     currentQuestion = currentQuestion + 1
     if currentQuestion > #wordlist then
        labelEnd.label = "You reached the last question"
        labelEnd:set_markup("<span foreground='green'>" .. labelEnd.label .. "</span>")
        restartButton:set_visible(true)
        labelEndCorrect.label = "correct: " .. correct_answers
        labelEndCorrect:set_markup("<span foreground='green'>" .. labelEndCorrect.label .. "</span>")
        labelEndIncorrect.label = "Incorrect: " .. incorrect_answers
        labelEndIncorrect:set_markup("<span foreground='red'>" .. labelEndIncorrect.label .. "</span>")
        summaryButton:set_visible(true)
        backButton:set_margin_top(30)

     end

     -- Hide all question elements
     for i = 1, #wordlist do
        question_labels[i]:set_visible(false)
        entry_fields[i]:set_visible(false)
        submit_buttons[i]:set_visible(false)
        result_labels[i]:set_visible(false)
        next_buttons[i]:set_visible(false)
     end

     -- Show the active question elements
     if question_labels[currentQuestion] == nil then 
       local trash 
     else
       question_labels[currentQuestion]:set_visible(true)
     end
     
     if entry_fields[currentQuestion] == nil then 
       local trash 
     else
       entry_fields[currentQuestion]:set_visible(true)
     end

     if submit_buttons[currentQuestion] == nil then 
       local trash 
     else
       submit_buttons[currentQuestion]:set_visible(true)
     end

     if result_labels[currentQuestion] == nil then 
       local trash 
     else
       result_labels[currentQuestion]:set_visible(true)
     end

     if next_buttons[currentQuestion] == nil then 
       local trash 
     else
       next_buttons[currentQuestion]:set_visible(false)
     end

     
     -- Retunr currentquestion variable
     return currentQuestion
end


-- Returns the functions
return import
