#!/usr/bin/env lua

-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')
local lfs = require("lfs")

-- Imports show_result function so you can see how many correct answers you have
local showResultModule = require("lua/showResult")
local show_result = showResultModule.show_result
local correct_answers = showResultModule.correct_answers
local incorrect_answers = showResultModule.incorrect_answers

-- Variables to make the application id
local appID2 = "io.github.Miqueas.GTK-Examples.Lua.Gtk4.ComboBox"
local appID1 = "io.github.Phoenix988.azla.main.lua"
local appTitle = "Azla"
local app1 = Gtk.Application({ application_id = appID1 })
local app2 = Gtk.Application({ application_id = appID2 })

-- function to easy create image widgets to the Gtk window
local function create_image(path)
    local image = Gtk.Image()
    local pixbuf = GdkPixbuf.Pixbuf.new_from_file(path)
    image:set_from_pixbuf(pixbuf)
    return image
end

-- Defines the words
local wordlist = {
   {"alma", "apple"},
   {"banan", "banana"},
   {"maşın", "car"},
   -- Add more words as needed
}

--local wordlistModule = require('lua_words/colors')
--
--local wordlist = wordlistModule.wordlist

-- Define other variables used later in the application
local question_labels = {}
local entry_fields = {}
local submit_buttons = {}
local result_labels = {}

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

-- Creates the window where you input answers in azerbajani
function app2:on_startup()

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

-- Makes the main startup window
function app1:on_startup()
  local win = Gtk.ApplicationWindow({
    title = appTitle,
    application = self,
    class = "Azla",
    default_width = 600,
    default_height = 600,
    on_destroy = Gtk.main_quit
  })


  -- Model for the combo box
  local model = Gtk.ListStore.new({ GObject.Type.STRING })

  -- Model for the second combo box
  local modelWord = Gtk.ListStore.new({ GObject.Type.STRING })
  
  -- Define language options
  local items = {
    "Azerbaijan",
    "English"
  }

-- Function to list all word files
local function getLuaFilesInDirectory(directory)
   local luaFiles = {}

   for file in lfs.dir(directory) do
      local filePath = directory .. "/" .. file
      if lfs.attributes(filePath, "mode") == "file" and file:match("%.lua$") then
         table.insert(luaFiles, filePath)
      end
   end

   return luaFiles
end

local directoryPath = "lua_words"
local luaFiles = getLuaFilesInDirectory(directoryPath)

  -- Add the items to the model
  for _, name in ipairs(items) do
    model:append({ name })
  end

  
-- Add items to the wordfile combo box
for _, luafiles in ipairs(luaFiles) do
    modelWord:append({ luafiles })
end

-- Some labels used on the startup window
local label = Gtk.Label({ label = "Default option: 0" })
local label2 = Gtk.Label({ 
                          label = "Welcome to AZLA",
                          width_request = 200,  -- Set the desired width
                          height_request = 100,
                          wrap = true })


-- Makes the combobox widgets
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

local comboWord = Gtk.ComboBox({
  model = modelWord,
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


  -- Changes the 'label' text when user change the combo box value
function comboWord:on_changed()
  local n = self:get_active()
  label.label = "WordList "..n.." selected ("..luaFiles[n + 1]..")"
end


-- Makes the main box widget to be used 
local box = Gtk.Box({
  orientation = Gtk.Orientation.VERTICAL,
  spacing = 10,
  halign = Gtk.Align.CENTER,
  valign = Gtk.Align.CENTER
})

-- Create the start button
local button = Gtk.Button({label = "Start"})
  

-- Create the function when you press on start
function button:on_clicked()
 -- stack:set_visible_child_name("second")
    local active = combo:get_active()
    if active == 0 then
    win:hide() 
    app2:run()
    elseif active == 1 then
    win:hide() 
    end
end

-- Creates the image
local image = create_image("/home/karl/myrepos/azla/images/wp2106881.jpg")
    
    -- Adds the widgets to the Main window
    box:append(image)
    box:append(label2)
    box:append(Gtk.Label({ label = "Select an option" }))
    box:append(combo)
    box:append(comboWord)
    box:append(label)
    box:append(button)

  -- Appends box to the main window
    win.child = box

end

-- Activate app1
function app1:on_activate()
  self.active_window:present()
end

-- Activate app2
function app2:on_activate()
  self.active_window:present()
end

-- Run the main app
return app1:run({})
