--{{Function to run the questions for my Azla GTK app

-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")
local replace           = require("lua.question.replace")
local response          = require("lua.question.response")
local list              = require("lua.terminal.listFiles")

local count = 0

question = {}
-- Counts correct answer to export
question.correct = 0
question.incorrect = 0
question.current = 0


-- Runs the function
function question.main(wordlist,
                       w,
                       box,
                       currentQuestion)

     -- Making empty widgets
     w.question_labels    = {}
     w.submit_buttons     = {}
     w.current_labels     = {}
     w.next_buttons       = {}
     w.entry_fields       = {}
     w.result_labels      = {}
     w.show_result_labels = {}


     -- Imports main window module
     local mainWindowModule  = require("lua.main").getWordList
     
     -- Gets the word count choice 
     local wordlistCount = getWordList()
      

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
      
     -- Gets the wordlist count value of the combo count box
     local count = tonumber(wordlist.count)

     -- Iterate over the wordlist using a for loop
     -- for i = 1, #wordlist do
      for i = 1, math.min(#wordlist, count) do
 
          question.current = question.current + 1
          
          -- Gets the correct answer and stores it in a variable
          local correct = string.lower(wordlist[i][languageNumber_1])
          local word = wordlist[i][languageNumber_2]
          local word = list.to_upper(word)


           -- Function to create a label with multiple span sections
           function question.create_label(spans)
             local label = Gtk.Label()
             local markup = ""
           
             for i, span in ipairs(spans) do
                 markup = markup .. string.format("<span %s>%s</span>", span.attributes, span.text)
             end

             label:set_markup(markup)
           
             return label
           end


           w.question_labels[i] = question.create_label(
              {
                { attributes = "weight='bold' foreground='" .. theme.label_question .. "'", text = question.current },
                { attributes = "weight='bold'", text = " What is " },
                { attributes = "size='" .. theme.label_question_size .. "' foreground='" .. theme.label_question .. "'", text = word },
                { attributes = "weight='bold'", text = " " .. languageString }
              }
          )
           
          -- Create labels that displays current question
          w.current_labels[i] = Gtk.Label {label = "Current: " .. question.current }
          w.current_labels[i]:set_markup("<span size='" .. theme.label_fg_size .. "" .. 
          "' foreground='" .. theme.label_question .. "'>" .. w.current_labels[i].label .. "</span>"  )

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
              currentQuestion = switchQuestion(question, 
              w,
              wg,
              restartButton,
              summaryButton,
              backButton)

          end
  
          -- Create result label for each question
          w.result_labels[i] = Gtk.Label()

          w.show_result_labels[i] = Gtk.Label({visible = false})
  
          -- Define the callback function for the submit button
          w.submit_buttons[i].on_clicked = function()
          local choice = w.entry_fields[i].text:lower()
          
          -- Alternative correct answer
          local altCorrect = replace.replace_main(correct)

          -- sets dont run variable
          local dontRun    = false

          -- create all the labels imported from respones.lua in this dir
          response.labels(correct, choice)
          local correctString =  response.correctString
          local correctStringAlt = response.correctStringAlt  
          local correctLabel = response.correctLabel
          local incorrectString = response.incorrectString
          local incorrectLabel = response.incorrectLabel
          
          -- Evaluates if answer is correct
          if choice == correct then
               
               -- runs the function
               question.correct = question.correct + 1
               local opt = "correct"
               correct_answers = response.main(opt, correctString,
                             w,i, correctLabel,choice, theme)
  
          else
               for key,value in pairs(altCorrect) do
                   if value == choice then

                       -- runs the function
                       local opt = "correct"
                       response.main(opt, correctStringAlt,
                             w,i, correctLabel,choice, theme)
                                               
                        -- Wont run next statement if this runs
                        dontRun = true
                      
                   end
               end
                
          end  -- End of if Statement
            
          -- Runs if answer is incorrect
          if choice ~= correct and not dontRun then
             
               question.incorrect = question.incorrect + 1
               -- runs the function
               local opt = "incorrect"
               response.main(opt,incorrectString,
                           w,i, incorrectLabel,choice, theme)
          elseif dontRun then
                question.correct = question.correct + 1
          end

  
        end
 
        -- Sets default visibility of all widgets
        for widget, _ in pairs(w) do
               if i == 1 then
                  w[widget][i]:set_visible(true)
               else
                  w[widget][i]:set_visible(false)
               end
        end

        if i == 1 then
               w.next_buttons[i]:set_visible(false)
        end
        
        -- Appends them all to the main box
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
