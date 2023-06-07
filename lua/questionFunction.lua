--{{Function to run the questions for my Azla GTK app

-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")


-- Runs the function
local function question_main(wordlist,
                             question_labels,
                             entry_fields,
                             result_labels,
                             show_result_labels,
                             submit_buttons,
                             next_buttons,
                             box,
                             correct_answers,
                             incorrect_answers,
                             currentQuestion)
      
      -- Import switchquestion function
      local import = require("lua.switchQuestion")
      local switchQuestion = import.switchQuestion

      -- Imports the variable needed to determine which language you choose
      local mainWindowModule = require("lua.mainWindow")
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
     
      -- Iterate over the wordlist using a for loop
      for i = 1, #wordlist do

          -- Gets the correct answer and stores it in a variable
          local correct = string.lower(wordlist[i][languageNumber_1])
          local word = wordlist[i][languageNumber_2]
           
          -- Create question label for each word in the list
          question_labels[i] = Gtk.Label {
               label = "<span weight='bold'>What is</span> <span size='" .. theme.label_question_size .. "".. 
               "' foreground='" .. theme.label_question .. "'>" .. word .. "</span>"..
               "<span weight='bold'> ".. languageString .. "</span>"
          }

          -- sets size of question label
          question_labels[i]:set_markup("<span size='" .. theme.label_question_size .. "" .. 
          "' foreground='" .. theme.label_fg .. "'>" .. question_labels[i].label .. "</span>"  )
  
          -- Create entry field for each question
          entry_fields[i] = Gtk.Entry()

          entry_fields[i]:set_size_request(200, 50) -- Set width = 200, height = 100
  
          -- Create submit button for each question
          submit_buttons[i] = Gtk.Button {
             label = "Submit"
          }
  
          -- Create next button for each question
          next_buttons[i] = Gtk.Button({label = "Next"})
  
          -- Create next button action and in this case it will call switchQuestion
          next_buttons[i].on_clicked = function ()
              question_labels[currentQuestion]:set_visible(false)
              -- Move to the next question
              switchQuestion(correct_answers, 
              incorrect_answers, 
              question_labels,
              entry_fields,
              submit_buttons,
              result_labels,
              next_buttons,
              labelEnd,
              labelEndCorrect,
              labelEndIncorrect,
              restartButton,
              summaryButton,
              backButton)
          end
  
          -- Create result label for each question
          result_labels[i] = Gtk.Label()

          show_result_labels[i]   = Gtk.Label({visible = false})
  
          -- Define the callback function for the submit button
          submit_buttons[i].on_clicked = function()
          local choice = entry_fields[i].text:lower()
  
          -- Evaluates if answer is correct
          if choice == correct then
               correct_answers = correct_answers + 1
               result_labels[i].label = "Congratulations, your answer is correct!"
               show_result_labels[i].label = "Correct: " .. correct .. " Answer: " .. choice
               show_result_labels[i]:set_markup("<span foreground='" .. theme.label_correct .. "'>" .. show_result_labels[i].label .. "</span>")
               show_result_labels[i]:set_markup("<span size='15000'>".. show_result_labels[i].label .. "</span>"  )
               result_labels[i]:set_markup("<span foreground='" .. theme.label_correct .. "'>" .. result_labels[i].label .. "</span>")
               result_labels[i]:set_markup("<span size='18000'>" .. result_labels[i].label .. "</span>"  )
               submit_buttons[i]:set_visible(false)
               next_buttons[i]:set_visible(true)
  
          else
                
               incorrect_answers = incorrect_answers + 1
               result_labels[i].label = "Sorry, your answer is incorrect. Correct answer: " .. correct
               show_result_labels[i].label = "Correct: " .. correct .. " Answer: " .. choice
               show_result_labels[i]:set_markup("<span foreground='" .. theme.label_incorrect .. "'>" .. show_result_labels[i].label .. "</span>")
               show_result_labels[i]:set_markup("<span size='15000'>" .. show_result_labels[i].label .. "</span>"  )
               result_labels[i]:set_markup("<span foreground='" .. theme.label_incorrect .. "'>" .. result_labels[i].label .. "</span>")
               result_labels[i]:set_markup("<span size='18000'>" .. result_labels[i].label .. "</span>"  )
               submit_buttons[i]:set_visible(false)
               next_buttons[i]:set_visible(true)
  
          end  -- End of if Statement
  
       end
  
         if i == 1 then
            question_labels[i]:set_visible(true)
            entry_fields[i]:set_visible(true)
            result_labels[i]:set_visible(true)
            submit_buttons[i]:set_visible(true)
            next_buttons[i]:set_visible(false)
         else
            question_labels[i]:set_visible(false)
            entry_fields[i]:set_visible(false)
            result_labels[i]:set_visible(false)
            submit_buttons[i]:set_visible(false)
            next_buttons[i]:set_visible(false)
         end
  
         box:append(question_labels[i])
         box:append(entry_fields[i])
         box:append(result_labels[i])
         box:append(submit_buttons[i])
         box:append(next_buttons[i])
         box:append(show_result_labels[i])
  
      end -- End for loop

end

return question_main
