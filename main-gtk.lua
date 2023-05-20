#!/usr/bin/env lua

local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')

-- Azla: A language Learning program

local appID = "io.github.Miqueas.GTK-Examples.Lua.Gtk4.ComboBox"
local appTitle = "Azla"
local app = Gtk.Application({ application_id = appID })

function runQuestion()
   question("question.lua")
end


local function create_image(path)
    local image = Gtk.Image()
    local pixbuf = GdkPixbuf.Pixbuf.new_from_file(path)
    image:set_from_pixbuf(pixbuf)
    return image
end


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

local function question_main(wordlist)

   local current_question = 1

   local shouldContinue = true

    correct_answers = 0
    incorrect_answers = 0

   for i = 1, #wordlist do

      if not shouldContinue then

      break

      end

      local currentQuestion = 1

      local correct = wordlist[i][1]
      local correct = string.lower(correct)

      local word = wordlist[i][2]
      local word_firstLetter = word:sub(1, 1):upper()
      local word_restofword = word:sub(2)
      local word = word_firstLetter .. word_restofword

      local dialog = Gtk.MessageDialog {
         message_type = Gtk.MessageType.QUESTION,
         buttons = Gtk.ButtonsType.OK_CANCEL,
         title = "Azla",
         text = "Answer the question",
         secondary_text = "What is " .. word .. " in Azerbajani?"
      }

     dialog.on_response:connect(function(dialog, response_id)
          if response_id == Gtk.ResponseType.CANCEL then
              shouldContinue = false -- Set the flag to break the loop
          end
          dialog:destroy() -- Close the dialog after the response
      end)

      local entry = Gtk.Entry()

      dialog:get_content_area():append(entry)
      dialog:show()


      local response_callback = function(dialog, response)
      local choice = entry:get_text():lower()

      dialog:destroy()

      if response == Gtk.ResponseType.OK then
         if choice == correct then
            correct_answers = correct_answers + 1
            right = Gtk.MessageDialog {
               message_type = Gtk.MessageType.INFO,
               buttons = Gtk.ButtonsType.OK,
               text = "Congratulations, your answer is correct!"
            }
             right:show()

             right.on_response = function(right, response_id)
                 if response_id == Gtk.ResponseType.OK then
                     right:close()  -- Close the dialog
                 end
             end


         else
            incorrect_answers = incorrect_answers + 1
            notRight = Gtk.MessageDialog {
               message_type = Gtk.MessageType.ERROR,
               buttons = Gtk.ButtonsType.OK,
               text = "Sorry, your answer is incorrect.",
               secondary_text = "Correct answer: " .. correct
            }

             notRight:show()

             notRight.on_response = function(notRight, response_id)
                 if response_id == Gtk.ResponseType.OK then
                     notRight:close()  -- Close the dialog
                 end
             end

         end

      end

      dialog:destroy()


   end


    dialog.on_response = response_callback


  end
    
end



local function question_alt(wordlist)
   local correct_answers = 0
   local incorrect_answers = 0
   local current_question = 1

   local function show_question()
      if current_question > #wordlist then
         -- All questions have been asked, show the result
         print("Correct Answers:", correct_answers)
         print("Incorrect Answers:", incorrect_answers)
         return
      end

      local correct = string.lower(wordlist[current_question][1])
      local word = wordlist[current_question][2]

      -- Create a label for the question
      local question_label = Gtk.Label {
         label = "What is " .. word .. " in Azerbajani?"
      }

      -- Create an entry field for the user's answer
      local entry = Gtk.Entry()

      -- Create a button to submit the answer
      local submit_button = Gtk.Button {
         label = "Submit"
      }

      -- Create a label to display the result
      local result_label = Gtk.Label()

      -- Define the callback function for the submit button
      submit_button.on_clicked = function()
         local choice = entry.text:lower()

         if choice == correct then
            correct_answers = correct_answers + 1
            result_label.label = "Congratulations, your answer is correct!"
            result_label:set_markup("<span foreground='green'>" .. result_label.label .. "</span>")
         else
            incorrect_answers = incorrect_answers + 1
            result_label.label = "Sorry, your answer is incorrect. Correct answer: " .. correct
            result_label:set_markup("<span foreground='red'>" .. result_label.label .. "</span>")
         end

         current_question = current_question + 1
         show_question()  -- Proceed to the next question
      end

      -- Create a vertical box to hold the components
      local vbox = Gtk.Box {
         orientation = Gtk.Orientation.VERTICAL,
         spacing = 10,
         margin_top = 20,
         margin_bottom = 20,
         margin_start = 20,
         margin_end = 20
      }
      vbox:append(question_label, false, false, 0)
      vbox:append(entry, false, false, 0)
      vbox:append(submit_button, false, false, 0)
      vbox:append(result_label, false, false, 0)

      -- Show the components in a window
      local window = Gtk.Window {
         title = "Azla",
         default_width = 400,
         default_height = 200,
         on_destroy = Gtk.main_quit
      }
    
    window.child = vbox

    
   Gtk.main_iteration_do()
   end

   show_question()  -- Start asking the questions
end




local function createFirstScreen(stack)
   local label = Gtk.Label {
      label = "Welcome to the Language Learning Program!",
      halign = Gtk.Align.CENTER,
      valign = Gtk.Align.CENTER,
      width_request = 200,
      height_request = 100,
   }

  local firstBox = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER
  })


   local entry_frst = Gtk.Entry()

   stack:add_titled(label,"first", "Main")

    
   return { label, firstBox}
end


local function createSecondScreen(stack)
   local label = Gtk.Label {
      label = "English",
      halign = Gtk.Align.CENTER,
      valign = Gtk.Align.CENTER,
      width_request = 200,
      height_request = 100,
      wrap = true
   }

   local box = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER
  })


   stack:add_titled(label, "second", "Alt")

   return label
end


function app:on_startup()
  local win = Gtk.ApplicationWindow({
    title = appTitle,
    application = self,
    class = "Azla",
    default_width = 400,
    default_height = 400
  })

  local Entry = Gtk.Entry {
      placeholder_text = "Enter a word",
      halign = Gtk.Align.CENTER,
      valign = Gtk.Align.CENTER
   }

   local stack = Gtk.Stack()
   local stackSwitcher = Gtk.StackSwitcher { stack = stack }

   local firstScreen = createFirstScreen(stack)
   local secondScreen = createSecondScreen(stack)

  -- Model for the combo box
  local model = Gtk.ListStore.new({ GObject.Type.STRING })
  local items = {
    "Azerbaijan",
    "English"
  }
  

   local wordlist = {
      {"alma", "apple"},
      {"banan", "muz"},
      {"maşın", "car"},
      -- Add more words as needed
   }

   --local wordlistModule = require('lua_words/colors')

   --local wordlist = wordlistModule.wordlist


  -- Add the items to the model
  for _, name in ipairs(items) do
    model:append({ name })
  end

  -- Label to be updated
  local label = Gtk.Label({  label = "Default option: 0" })
  local label2 = Gtk.Label({ label = "Welcome to AZLA",
                             width_request = 200,  -- Set the desired width
                             height_request = 100,
                              wrap = true })

  local combo = Gtk.ComboBox({
    model = model,
    active = 0,
    cells = {
      {
        Gtk.CellRendererText(),
        { text = 1 },
        align = Gtk.Align.START
      }
    }
  })

  -- Changes the 'label' text when user change the combo box value
  function combo:on_changed()
    local n = self:get_active()
    label.label = "Option "..n.." selected ("..items[n + 1]..")"
  end

  local box = Gtk.Box({
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    halign = Gtk.Align.CENTER,
    valign = Gtk.Align.CENTER
  })

   local button = Gtk.Button({
    label = "Start"
   })


   local button2 = Gtk.Button({
    label = "Show Result",
   })

   function button:on_clicked()
    -- stack:set_visible_child_name("second")
     runQuestion()
   end

   function button2:on_clicked()
   show_result(correct_answers)
   end

local image = create_image("/home/karl/myrepos/azla/images/wp2106881.jpg")


  box:append(image)
  box:append(label2)
  box:append(Gtk.Label({ label = "Select an option" }))
  box:append(combo)
  box:append(label)
  box:append(button)
  box:append(button2)
  box:append(stack)
  box:append(stack)
  box:append(stackSwitcher)

  win.child = box

end

function app:on_activate()
  self.active_window:present()
end

return app:run(arg)
