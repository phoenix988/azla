-- Imports of Libaries
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")

-- Other imports and global variables
-- Imports function to create images
local imageModule       = require("lua/createImage")
local create_image      = imageModule.create_image

-- Define home variable
local home              = os.getenv("HOME")
local imagePath         = "/opt/azla/images/flag.jpg"

-- Define other variables used later in the application
local question_labels   = {}
local entry_fields      = {}
local submit_buttons    = {}
local result_labels     = {}
local next_buttons      = {}

-- Counts correct answers
local correct_answers   = 0
local incorrect_answers = 0

-- Sets app attributes
local appID2            = "io.github.Phoenix988.azla.az.lua"
local appTitle          = "Azla Question"
local app2              = Gtk.Application({ application_id = appID2 })

-- Import the show_result function from resultModule.lua
local resultModule = require("lua/showResult")
local show_result = resultModule.show_result

-- Calculates current question
local currentQuestion = 1

-- Function so it switch question after you submit your answer
local function switchQuestion()
     currentQuestion = currentQuestion + 1
     if currentQuestion > #wordlist then
        labelEnd.label = "You reached the last question"
        labelEnd:set_markup("<span foreground='green'>" .. labelEnd.label .. "</span>")
        restartButton:set_visible(true)
        labelEndCorrect.label = "correct: " .. correct_answers
        labelEndCorrect:set_markup("<span foreground='green'>" .. labelEndCorrect.label .. "</span>")
        labelEndIncorrect.label = "Incorrect: " .. incorrect_answers
        labelEndIncorrect:set_markup("<span foreground='red'>" .. labelEndIncorrect.label .. "</span>")

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
     question_labels[currentQuestion]:set_visible(true)
     entry_fields[currentQuestion]:set_visible(true)
     submit_buttons[currentQuestion]:set_visible(true)
     result_labels[currentQuestion]:set_visible(true)
     next_buttons[currentQuestion]:set_visible(false)
end


local function create_app2()
    -- Create the application object
    local app2 = Gtk.Application({
        application_id = appID2,
        flags = {"HANDLES_OPEN"}
    })

  -- Create the main window function
  function app2:on_activate()
      
      local mainWindowModule = require("lua/mainWindow")
      local getWidth = mainWindowModule.getWindowWidth
      local getHeight = mainWindowModule.getWindowHeight
      local width = getWindowWidth()
      local height = getWindowHeight()

      local win = Gtk.ApplicationWindow({
         title = appTitle,
         application = self,
         class = "Azla",
         default_width = width,
         default_height = height,
         on_destroy = Gtk.main_quit,
         decorated = true,
         deletable = true,
      })

  
      local boxMain = Gtk.Box({
          orientation = Gtk.Orientation.VERTICAL,
          spacing = 10,
      })

      -- Makes the main box widget to be used 
      local box = Gtk.Box({
          orientation = Gtk.Orientation.VERTICAL,
          spacing = 10,
          halign = Gtk.Align.FILL,
          valign = Gtk.Align.CENTER,
          hexpand = true,
          vexpand = true,
          margin_top    = 30,
          margin_bottom = 30,
          margin_start  = 200,
          margin_end    = 200
      })

      local boxAlt = Gtk.Box({
          orientation = Gtk.Orientation.VERTICAL,
          spacing = 10,
          halign = Gtk.Align.FILL,
          valign = Gtk.Align.CENTER,
          hexpand = true,
          vexpand = true,
          margin_top    = 40,
          margin_bottom = 40,
          margin_start  = 30,
          margin_end    = 30
      })

      -- Creates image for the app
      local image = create_image(imagePath)
      image:set_size_request(200, 150)
       
      -- Appends the image on the top
      box:append(image)
  
      -- Function to Shuffle the wordlist array
      local function shuffle(wordlist)
          local rand = math.random
          local iterations = #wordlist
      
          for i = iterations, 2, -1 do
              local j = rand(i)
              wordlist[i], wordlist[j] = wordlist[j], wordlist[i]
          end
      end
      
      -- Calls the shuffle function
      shuffle(wordlist)
      
      -- Imports the variable needed to determine which language you choose
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
             label = "What is " .. word .. " " .. languageString .. " ?"
          }

          -- sets size of question label
          question_labels[i]:set_markup("<span size='20000'>" .. question_labels[i].label .. "</span>"  )
  
          -- Create entry field for each question
          entry_fields[i] = Gtk.Entry()

          entry_fields[i]:set_size_request(200, 100) -- Set width = 200, height = 100
  
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
              switchQuestion()
          end
  
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
               result_labels[i]:set_markup("<span size='18000'>" .. result_labels[i].label .. "</span>"  )
               submit_buttons[i]:set_visible(false)
               next_buttons[i]:set_visible(true)
  
          else
                
               incorrect_answers = incorrect_answers + 1
               result_labels[i].label = "Sorry, your answer is incorrect. Correct answer: " .. correct
               result_labels[i]:set_markup("<span foreground='red'>" .. result_labels[i].label .. "</span>")
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
  
  
  
      end -- End for loop
  
      -- Creates the labels shown at the end
      labelEnd = Gtk.Label()
      -- Counts correct answers
      labelEndCorrect = Gtk.Label()
      -- Counts incorrect answers
      labelEndIncorrect = Gtk.Label()

      local labelSept = Gtk.Label({label = ""})
  
      -- Creates the restart button if you want to restart the list
      restartButton = Gtk.Button({label = "Restart"})
      -- Initially you wont see the restartbutton
      restartButton:set_visible(false)
      
      -- Function called when clicking the restartbutton
      function restartButton:on_clicked() 
          
          -- Resets the variables that keep tracks of current 
          -- question and correct answers
          correct_answers = 0
          incorrect_answers = 0
          currentQuestion = 1  -- Start from the first question if reached the end
          
          -- Relaunch the app
          win:destroy()
          app2:activate()
  
      end
      
      -- Makes result button to show your result
      local resultButton = Gtk.Button({label = "Show Result"})
      
      -- Create back button to go back to main
      local backButton = Gtk.Button({label = "Go Back"})
      
      -- Makes exit button to exit
      local exitButton = Gtk.Button({label = "Exit"})
      
      -- Defines the function of Resultbutton
      function resultButton:on_clicked()
          show_result(correct_answers, incorrect_answers)
      end
      
      -- Imports window variable from mainWindow
      local mainWindowModule = require("lua/mainWindow")
      local mainWindow = mainWindowModule.app1
      
      -- Defines the function of Exitbutton
      function backButton:on_clicked()
          incorrect_answers = 0
          correct_answers   = 0
          win:destroy()
          mainWindow:activate()
      end

      function exitButton:on_clicked()
          win:destroy()
      end
  
      -- Appends these widgets to box
      box:append(labelEnd)
      box:append(labelEndCorrect)
      box:append(labelEndIncorrect)
      box:append(resultButton)
      box:append(restartButton)
      box:append(labelSept)
      box:append(backButton)
      box:append(labelSept)
      box:append(exitButton)

  
      -- Appends box to the main window
      win.child = box
      
      -- Presents the main GTK window
      win:present()
  
  end -- End of app2:on_activate function
  
  return app2

end -- End of create_app2 function

-- Returns the functions
return {app2 = app2, create_app2 = create_app2 }





