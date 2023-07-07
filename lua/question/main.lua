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
local style             = require("lua.widgets.setting")
local wordview          = require("lua.widgets.button.questionView")

local count = 0

question = {}

-- Counts correct answer to export
question.correct = 0
question.incorrect = 0
question.current = 0


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


-- Runs the function
function question.main(wordlist,
                       w,
                       mainGrid,
                       questionGrid,
                       currentQuestion,
                       bt)
 
     -- Load the theme and font to use
     local theme = require("lua.theme.default")
     local font  = theme.font.load()
     local theme = theme.load()
     
     -- Gets the current mode of Azla
     local mode = require("lua.main").getWordList()
     question.mode = require("lua.question.examMode")

     -- Making empty widgets
     w.question_labels    = {}
     w.submit_buttons     = {}
     w.current_labels     = {}
     w.next_buttons       = {}
     w.entry_fields       = {}
     w.result_labels      = {}
     w.show_result_labels = {}

     local prevButton = Gtk.Button({label = "Prev"})
     local submitButton = Gtk.Button({label = "Submit"})
     local nextButton = Gtk.Button({label = "Next"})

     local prevButton = style.set_theme(prevButton, {
     {size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg}
     })

     local submitButton = style.set_theme(submitButton, {
     {size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg}
     })

     local nextButton = style.set_theme(nextButton, {
     {size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg}
     })

     -- Imports wordlist choice
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

      local wordTable = {}
      
      -- Create a table to list the words in a tree
      for i = 1, math.min(#wordlist, count) do

          local word = wordlist[i][languageNumber_2]
          local word = list.to_upper(word)

          local append = i .. " " .. word
          table.insert(wordTable, append)

      end
      
      -- create treeView widget
      local treeView = wordview:create_tree(question.last,wordTable)
      wg.tree = questionGrid
      
      -- Iterate over the wordlist using a for loop
      -- for i = 1, #wordlist do
      for i = 1, math.min(#wordlist, count) do
          -- Counts current question
          question.current = question.current + 1
          question.last = i
          
          -- Gets the correct answer and stores it in a variable
          local correct = string.lower(wordlist[i][languageNumber_1])
          local word = wordlist[i][languageNumber_2]
          local word = list.to_upper(word)
          
           w.question_labels[i] = question.create_label(
              {
                { attributes = "weight='bold' foreground='" .. theme.label_question .. "'", text = question.current },
                { attributes = "weight='bold'", text = " What is " },
                { attributes = "size='" .. font.question_size .. "' foreground='" .. theme.label_question .. "'", text = word },
                { attributes = "weight='bold'", text = " " .. languageString }
              }
          )
           
          -- Create labels that displays current question
          w.current_labels[i] = Gtk.Label {label = "Current: " .. question.current }
          w.current_labels[i]:set_markup("<span size='" .. font.fg_size .. "" .. 
          "' foreground='" .. theme.label_question .. "'>" .. w.current_labels[i].label .. "</span>"  )

          -- sets size of question label
          w.question_labels[i]:set_markup("<span size='" .. font.question_size .. "" .. 
          "' foreground='" .. theme.label_fg .. "'>" .. w.question_labels[i].label .. "</span>"  )
  
          -- Create entry field for each question
          w.entry_fields[i] = Gtk.Entry()

          w.entry_fields[i]:set_size_request(200, 50) -- Set width = 200, height = 100

          -- Set style of entry box
          w.entry_fields[i] = style.set_theme(w.entry_fields[i], {
          {size = font.entry_size / 1000, color = theme.label_question, border_color = theme.label_fg}
          })
          
          -- Create submit button for each question
          w.submit_buttons[i] = Gtk.Button {
             label = "Submit"
          }

  
          -- Create next button for each question
          w.next_buttons[i] = Gtk.Button({label = "Next"})
          w.next_buttons[i]:set_size_request(100, 10)
          
          -- Sets theme of next and submit buttons
          style.set_theme(w.next_buttons[i],{
          {size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg}})
          style.set_theme(w.submit_buttons[i],{
          {size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_fg}})
  
          -- Create next button action and in this case it will call switchQuestion
          w.next_buttons[i].on_clicked = function ()
              w.question_labels[currentQuestion]:set_visible(false)

              -- Move to the next question
              currentQuestion = switchQuestion(
              true,
              question, 
              w,
              wg,
              bt)

              if mode.mode == true then
                 if w.next_buttons[currentQuestion] ~= nil then
                    w.next_buttons[currentQuestion]:set_visible(true)
                 end 
                 if currentQuestion == question.last then
                    w.next_buttons[currentQuestion]:set_visible(false)
                    submitButton:set_visible(true)
                 end   

              end

             local model = treeView:get_model()
             -- Get the tree selection and set the default selection
             local selection = treeView:get_selection()
             local model = treeView:get_model()
             local iter = model:get_iter_from_string(tostring(currentQuestion - 1)) -- Select the first row
             if currentQuestion <= question.last then
                selection:select_iter(iter)
             end
                

          end
  
          -- Create result label for each question
          w.result_labels[i] = Gtk.Label({visible = false})

          w.show_result_labels[i] = Gtk.Label({visible = false})
  
          -- Define the callback function for the submit button
          w.submit_buttons[i].on_clicked = function()
              local choice = w.entry_fields[i].text:lower()
              
              -- Alternative correct answer
              local altCorrect = replace.replace_main(correct)

              -- sets dont run variable
              local dontRun    = false

              -- create all the labels imported from respones.lua in this dir
              response.labels(correct, choice, word)
              local correctString    =  response.correctString
              local correctStringAlt = response.correctStringAlt  
              local correctLabel     = response.correctLabel
              local incorrectString  = response.incorrectString
              local incorrectLabel   = response.incorrectLabel
              
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

              w.entry_fields[i]:set_editable(false)
                
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
          elseif mode.mode == true then       
                 w.next_buttons[currentQuestion]:set_visible(true)
          end

        
          -- Appends them all to the main box
          mainGrid:attach(w.question_labels[i],0,0,1,1)
          mainGrid:attach(w.entry_fields[i],0,1,1,1)
          if mode.mode == false then
             mainGrid:attach(w.result_labels[i],0,2,1,1)
             mainGrid:attach(w.submit_buttons[i],0,3,1,1)
             mainGrid:attach(w.next_buttons[i],0,4,1,1)
          end   
          mainGrid:attach(w.show_result_labels[i],0,5,1,1)
      
          count = count + 1

      end -- End for loop

      if mode.mode == true then
          mainGrid:attach(prevButton,0,5,1,1)
          mainGrid:attach(submitButton,0,4,1,1)
          mainGrid:attach(nextButton,0,4,1,1)
          submitButton:set_visible(false)
      end   



     questionGrid:attach(treeView,0,0,1,1)

     local selection = treeView:get_selection()

     selection.on_changed:connect(function()
          
          local selection = treeView:get_selection()
             local model, iter = selection:get_selected()
             if model and iter then
                local value = model:get_value(iter, 0) -- Assuming the value is in column 0
                stringValue = value:get_string() -- Convert value to string
          end


           local stringValue = string.match(stringValue, "(%d+)%s")
          
           local stringValue = tonumber(stringValue)
           -- Move to the next question
           currentQuestion = switchQuestion(
           stringValue,
           question, 
           w,
           wg,
           bt)

           if mode.mode == false then
              w.next_buttons[stringValue]:set_visible(false)
           end

           if stringValue == question.last and mode.mode == true then
              submitButton:set_visible(true)
              nextButton:set_visible(false)
           else   
              submitButton:set_visible(false)
              nextButton:set_visible(true)
           end

     end)
   
     -- Button to go back one question
     function prevButton:on_clicked()
           submitButton:set_visible(false)

           if currentQuestion == 1 then
              local pop = require("lua.question.popups")

              pop.first_question()
           
           end

           -- Move to the next question
           currentQuestion = switchQuestion(
           false,
           question, 
           w,
           wg,
           bt)

           local model = treeView:get_model()
           -- Get the tree selection and set the default selection
           local selection = treeView:get_selection()
           local model = treeView:get_model()
           local iter = model:get_iter_from_string(tostring(currentQuestion - 1)) -- Select the first row
           selection:select_iter(iter)


           
           if currentQuestion < question.last then
              nextButton:set_visible(true)
           end

     end

     -- Define the callback function for the submit button
     submitButton.on_clicked = function()
            -- runs the exam mode evaluation on all your answers
            local choice = question.mode.exam(w,question.last,response,replace,list)
            
            -- Will run if you didn't complete all questions
            if question.complete == false then
               local pop = require("lua.question.popups")
               currentQuestion = pop.are_you_sure(currentQuestion, switchQuestion, question,
                                 prevButton,submitButton,w,wg,bt,theme,font)
            else
            
               -- Move to the next question
               currentQuestion = switchQuestion(
               true,
               question, 
               w,
               wg,
               bt)

               if currentQuestion > question.last then
                  prevButton:set_visible(false)
                  submitButton:set_visible(false)
               end  
            end
    end       
    
    -- Single next button made for exam mode
    nextButton.on_clicked = function()
          if currentQuestion == question.last - 1 then
             nextButton:set_visible(false)
             submitButton:set_visible(true)
          end   

          
          -- Move to the next question
          currentQuestion = switchQuestion(
          true,
          question, 
          w,
          wg,
          bt)

          current = currentQuestion
          
          wordview.listStore:clear()

          for i = 1, question.last do
             local word = wordlist[i][languageNumber_2]
             local word = list.to_upper(word)
             if i == current - 1 then
                  word = word .. " V"
             end
             wordview.listStore:append({i .. " " .. word})
          end

          local model = treeView:get_model()
          -- Get the tree selection and set the default selection
          local selection = treeView:get_selection()
          local model = treeView:get_model()
          local iter = model:get_iter_from_string(tostring(current - 1)) -- Select the first row
          if currentQuestion <= question.last then
             selection:select_iter(iter)
          end

          
    end

    
end

return question
