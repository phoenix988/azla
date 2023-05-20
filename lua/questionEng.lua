local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')
local lfs = require("lfs")

local imageModule = require("lua/createImage")
local create_image = imageModule.create_image

-- Define other variables used later in the application
local question_labels = {}
local entry_fields = {}
local submit_buttons = {}
local result_labels = {}

local correct_answers = 0
local incorrect_answers = 0

local appID3 = "io.github.Phoenix988.azla.eng.lua"

local app3 = Gtk.Application({ application_id = appID3 })

local function show_result(correct_answers)


   if correct_answers == nil then
      local dialog_empty = Gtk.MessageDialog {
         message_type = Gtk.MessageType.ERROR,
         buttons = Gtk.ButtonsType.OK,
         text = "No session run",
         }

     dialog_empty:show()

     dialog_empty.on_response = function(dialog_empty, response_id)
               if response_id == Gtk.ResponseType.OK then
                   dialog_empty:close()  -- Close the dialog
               end
           end

   else

    local dialog = Gtk.MessageDialog {
        message_type = Gtk.MessageType.INFO,
        buttons = Gtk.ButtonsType.OK,
        text = "Correct answers: " .. correct_answers,
        secondary_text = "Incorrect answers: " .. incorrect_answers,
       }
     
      dialog.on_response = function(dialog, response_id)
           if response_id == Gtk.ResponseType.OK then
               dialog:close()  -- Close the dialog
           end
         end

      dialog:show()

   end
 
end


-- Calculates current question
local currentQuestion = 1

-- Function so it switch question after you submit your answer
local function switchQuestion()
   currentQuestion = currentQuestion + 1
   if currentQuestion > #wordlist then
      currentQuestion = 1  -- Start from the first question if reached the end
   end

   -- Hide all question elements
   for i = 1, #wordlist do
      question_labels[i]:set_visible(false)
      entry_fields[i]:set_visible(false)
      submit_buttons[i]:set_visible(false)
      result_labels[i]:set_visible(false)
   end

   -- Show the active question elements
   question_labels[currentQuestion]:set_visible(true)
   entry_fields[currentQuestion]:set_visible(true)
   submit_buttons[currentQuestion]:set_visible(true)
   result_labels[currentQuestion]:set_visible(true)
end



function app3:on_startup()

-- Creates the main window
  local win = Gtk.ApplicationWindow({
    title = appTitle,
    application = self,
    class = "Azla",
    default_width = 600,
    default_height = 600
  })

  -- Box widget where I append all my widgets
  -- and decide placement
  local box = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER
  })

   -- Creates image for the app
   local image = create_image("/home/karl/myrepos/azla/images/wp2106881.jpg")
   box:append(image)

   -- Iterate over the wordlist using a for loop
   for i = 1, #wordlist do
      local correct = string.lower(wordlist[i][1])
      local word = wordlist[i][2]

      -- Create question label for each word in the list
      question_labels[i] = Gtk.Label {
         label = "What is " .. word .. " in Azerbaijani?"
      }

      -- Create entry field for each question
      entry_fields[i] = Gtk.Entry()

      -- Create submit button for each question
      submit_buttons[i] = Gtk.Button {
         label = "Submit"
      }

      -- Create result label for each question
      result_labels[i] = Gtk.Label()

      -- Define the callback function for the submit button
      submit_buttons[i].on_clicked = function()
         local choice = entry_fields[i].text:lower()

         -- Evaluates if answer is correct
         if choice == correct then
            correct_answers = correct_answers + 1
            result_labels[i].label = "Congratulations, your answer is correct!"
            result_labels[i]:set_markup("<span foreground='green'>" .. result_labels[i].label .. "</span>")

          local dialog = Gtk.MessageDialog {
            message_type = Gtk.MessageType.INFO,
            buttons = Gtk.ButtonsType.OK,
            text = "Click OK to move to the next question",
            secondary_text = "Congratulations, your answer is correct!"
         }

          dialog:show()

          dialog.on_response:connect(function(dialog, response_id)
          if response_id == Gtk.ResponseType.OK then
              shouldContinue = false -- Set the flag to break the loop
          end
          dialog:destroy() -- Close the dialog after the response
          end)

         else
            
            incorrect_answers = incorrect_answers + 1
            result_labels[i].label = "Sorry, your answer is incorrect. Correct answer: " .. correct
            result_labels[i]:set_markup("<span foreground='red'>" .. result_labels[i].label .. "</span>")

            local dialog = Gtk.MessageDialog {
            message_type = Gtk.MessageType.INFO,
            buttons = Gtk.ButtonsType.OK,
            text = "Click OK to move to the next question",
            secondary_text = "Sorry, your answer is incorrect. Correct answer: " .. correct
         }
            dialog:show()

          dialog.on_response:connect(function(dialog, response_id)
            if response_id == Gtk.ResponseType.OK then
                shouldContinue = false -- Set the flag to break the loop
            end
          dialog:destroy() -- Close the dialog after the response
          end)
         end  -- End of if Statement

         switchQuestion()  -- Move to the next question

      end


      if i == 1 then
         question_labels[i]:set_visible(true)
         entry_fields[i]:set_visible(true)
         submit_buttons[i]:set_visible(true)
         result_labels[i]:set_visible(true)
      else
         question_labels[i]:set_visible(false)
         entry_fields[i]:set_visible(false)
         submit_buttons[i]:set_visible(false)
         result_labels[i]:set_visible(false)
      end

      box:append(question_labels[i])
      box:append(entry_fields[i])
      box:append(submit_buttons[i])
      box:append(result_labels[i])

      local nextQuestion = i + 1
         if nextQuestion > #wordlist then
            nextQuestion = 1  -- Start from the first question if reached the end
         end


 end -- End for loop

-- Makes result button to show your result
local resultButton = Gtk.Button({label = "Show Result"})

-- Makes exit button to exit
local exitButton = Gtk.Button({label = "Exit"})

-- Defines the function of Resultbutton
function resultButton:on_clicked()
  show_result(correct_answers)
end

-- Defines the function of Exitbutton
function exitButton:on_clicked()
  win:destroy()
  app1:run()
end

  -- Appends these widgets to box
  box:append(resultButton)
  box:append(exitButton)

  -- Appends box to the main window
  win.child = box

end -- End of function




return { app3 = app3 }


