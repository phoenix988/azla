--{{Function to run the questions for my Azla GTK app

-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")

local count = 0

question = {}

-- Runs the function
function question.main(wordlist,
                       w,
                       box,
                       correct_answers,
                       incorrect_answers,
                       currentQuestion)

     -- Making empty widgets
     w.question_labels    = {}
     w.submit_buttons     = {}
     w.next_buttons       = {}
     w.entry_fields       = {}
     w.result_labels      = {}
     w.show_result_labels = {}


     -- Imports main window module
     local mainWindowModule  = require("lua.main").getWordList
     
     -- Gets the word count choice 
     local wordlistCount = getWordList()
      
      -- Counts correct answer to export
      question.correct = 0
      question.incorrect = 0

      -- Import switchquestion function
      local import = require("lua.switchQuestion")
      local switchQuestion = import.switchQuestion

      -- Imports the variable needed to determine which language you choose
      local mainWindowModule = require("lua.main")
      local getLanguageChoice = mainWindowModule.getLanguageChoice
      local languageChoice = getLanguageChoice()

      -- Sets the variables depending on choice
      if languageChoice == "azerbajani" then
         languageNumber_1 = 1
         languageNumber_2 = 2
         languageString = "in Azerbajani"
      elseif languageChoice == "english" then
         languageNumber_1 = 2
         languageNumber_2 = 1
         languageString = "in English"
      end
      
     local count = tonumber(wordlist.count)

     -- Iterate over the wordlist using a for loop
     -- for i = 1, #wordlist do
      for i = 1, math.min(#wordlist, count) do
          
          -- Gets the correct answer and stores it in a variable
          local correct = string.lower(wordlist[i][languageNumber_1])
          local word = wordlist[i][languageNumber_2]
           
          -- Create question label for each word in the list
          w.question_labels[i] = Gtk.Label {
               label = "<span weight='bold'>What is</span> <span size='" .. theme.label_question_size .. "".. 
               "' foreground='" .. theme.label_question .. "'>" .. word .. "</span>"..
               "<span weight='bold'> ".. languageString .. "</span>"
          }

          -- sets size of question label
          w.question_labels[i]:set_markup("<span size='" .. theme.label_question_size .. "" .. 
          "' foreground='" .. theme.label_fg .. "'>" .. w.question_labels[i].label .. "</span>"  )
  
          -- Create entry field for each question
          w.entry_fields[i] = Gtk.Entry()

          w.entry_fields[i]:set_size_request(200, 50) -- Set width = 200, height = 100
  
          -- Create submit button for each question
          w.submit_buttons[i] = Gtk.Button {
             label = "Submit"
          }
  
          -- Create next button for each question
          w.next_buttons[i] = Gtk.Button({label = "Next"})
  
          -- Create next button action and in this case it will call switchQuestion
          w.next_buttons[i].on_clicked = function ()
              w.question_labels[currentQuestion]:set_visible(false)

              -- Move to the next question
              switchQuestion(correct_answers, 
              incorrect_answers, 
              w,
              wg,
              restartButton,
              summaryButton,
              backButton)
          end
  
          -- Create result label for each question
          w.result_labels[i] = Gtk.Label()

          w.show_result_labels[i]   = Gtk.Label({visible = false})
  
          -- Define the callback function for the submit button
          w.submit_buttons[i].on_clicked = function()
          local choice = w.entry_fields[i].text:lower()
  
          -- Evaluates if answer is correct
          if choice == correct then
               correct_answers = correct_answers + 1
               question.correct = question.correct + 1
               w.result_labels[i].label = "Congratulations, your answer is correct!"
               w.show_result_labels[i].label = "Correct: " .. correct .. " Answer: " .. choice
               w.show_result_labels[i]:set_markup("<span foreground='" .. theme.label_correct .. "'>" .. w.show_result_labels[i].label .. "</span>")
               w.show_result_labels[i]:set_markup("<span size='15000'>".. w.show_result_labels[i].label .. "</span>"  )
               w.result_labels[i]:set_markup("<span foreground='" .. theme.label_correct .. "'>" .. w.result_labels[i].label .. "</span>")
               w.result_labels[i]:set_markup("<span size='18000'>" .. w.result_labels[i].label .. "</span>"  )
               w.submit_buttons[i]:set_visible(false)
               w.next_buttons[i]:set_visible(true)
               
               if question.label_correct == nil then
                   question.label_correct = {}
               end
               question.label_correct[i] = "Correct: " .. correct .. ":" .. "Answer: " .. choice
  
          else
                
               incorrect_answers = incorrect_answers + 1
               question.incorrect = question.incorrect + 1
               w.result_labels[i].label = "Sorry, your answer is incorrect. Correct answer: " .. correct
               w.show_result_labels[i].label = "Correct: " .. correct .. " Answer: " .. choice
               w.show_result_labels[i]:set_markup("<span foreground='" .. theme.label_incorrect .. "'>" .. w.show_result_labels[i].label .. "</span>")
               w.show_result_labels[i]:set_markup("<span size='15000'>" .. w.show_result_labels[i].label .. "</span>"  )
               w.result_labels[i]:set_markup("<span foreground='" .. theme.label_incorrect .. "'>" .. w.result_labels[i].label .. "</span>")
               w.result_labels[i]:set_markup("<span size='18000'>" .. w.result_labels[i].label .. "</span>"  )
               w.submit_buttons[i]:set_visible(false)
               w.next_buttons[i]:set_visible(true)

               if question.label_incorrect == nil then
                   question.label_incorrect = {}
               end
               question.label_incorrect[i] = "Correct: " .. correct .. ":" .. "Answer: " .. choice
  
          end  -- End of if Statement
  
       end
  
         if i == 1 then
            w.question_labels[i]:set_visible(true)
            w.entry_fields[i]:set_visible(true)
            w.result_labels[i]:set_visible(true)
            w.submit_buttons[i]:set_visible(true)
            w.next_buttons[i]:set_visible(false)
         else
            w.question_labels[i]:set_visible(false)
            w.entry_fields[i]:set_visible(false)
            w.result_labels[i]:set_visible(false)
            w.submit_buttons[i]:set_visible(false)
            w.next_buttons[i]:set_visible(false)
         end
  
         box:append(w.question_labels[i])
         box:append(w.entry_fields[i])
         box:append(w.result_labels[i])
         box:append(w.submit_buttons[i])
         box:append(w.next_buttons[i])
         box:append(w.show_result_labels[i])
      
      count = count + 1


      end -- End for loop

end

return question
