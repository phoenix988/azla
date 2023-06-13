-- Imports of Libaries
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local gio               = require("lgi").Gio
local lfs               = require("lfs")
local os                = require("os")

-- Import theme
local theme             = require("lua.theme.default")
local replace           = {}

-- Other imports and global variables
-- Imports function to create images
local imageModule       = require("lua.createImage")
local create_image      = imageModule.create_image

-- Define home variable
local home              = os.getenv("HOME")

-- Define image path
local imagePath         = theme.main_image

-- Cache file path
local cacheFile          = home .. "/.cache/azla.lua"

-- Import function to write to cache file
local writeToConfigModule   = require("lua.settings")
local writeTo_config        = writeToConfigModule.writeTo_config
local configReplace         = writeToConfigModule.setconfigReplace
local write                 = writeToConfigModule.write


-- Import the show_result function from resultModule.lua
local resultModule   = require("lua.showResult")
local show_result    = resultModule.show_result

-- Import SwitchQuestion function
local import         = require("lua.switchQuestion")
local switchQuestion = import.switchQuestion

-- Import the question Module
local question     = require("lua.questionFunction")
local questionMain = question.main

-- Import shuffle
local shuffle        = require("lua.shuffle")

-- Sets app attributes
local appID2            = "io.github.Phoenix988.azla.az.lua"
local appTitle          = "Azla Question"
local app2              = Gtk.Application({ application_id = appID2 })

local combo             = require("lua.widgets.combo")

-- Define other variables used later in the application
local question_labels    = {}
local entry_fields       = {}
local submit_buttons     = {}
local result_labels      = {}
local next_buttons       = {}
local show_result_labels = {}

-- Counts correct answers
local correct_answers   = 0
local incorrect_answers = 0

-- Calculates current question
local currentQuestion = 1

local function create_app2()
  -- Create the application object
  local app2 = Gtk.Application({
      application_id = appID2,
      flags = {"HANDLES_OPEN"}
  })

  -- Create the main window function
  function app2:on_activate()
      
      local mainWindowModule = require("lua.mainWindow")
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

      -- Creates image for the app
      local image = create_image(imagePath)
      image:set_size_request(200, 150)
       
      -- Appends the image on the top
      box:append(image)

      local getWordList = mainWindowModule.getWordList
      local wordlist = getWordList()
  
      -- Calls the shuffle function
      shuffle(wordlist)
      
      -- Runs the question Function
      questionMain(wordlist,
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
 
      -- Make end Label
      labelEnd = Gtk.Label()
      -- Counts correct answers
      labelEndCorrect = Gtk.Label()
      -- Counts incorrect answers
      labelEndIncorrect = Gtk.Label()
  
      -- Creates the restart button if you want to restart the list
      restartButton = Gtk.Button({label = "Restart"})
      -- Initially you wont see the restartbutton
      restartButton:set_visible(false)

      -- Makes grid
      local grid = Gtk.Grid()
      local grid2 = Gtk.Grid()
      
      -- Function called when clicking the restartbutton
      function restartButton:on_clicked() 
          -- Resets the variables that keep tracks of current 
          -- question and correct answers
          correct_answers = 0
          incorrect_answers = 0
          currentQuestion = 1  -- Start from the first question if reached the end

          question.label_correct = {}
          question.label_incorrect = {}

          import.setQuestion(currentQuestion)
          
          -- Relaunch the app
          win:destroy()
          app2:activate()
      end
      
      -- Makes result button to show your result
      local resultButton = Gtk.Button({label = "Show Result"})

      summaryButton = Gtk.Button({label = "Summary"})
      continueButton = Gtk.Button({label = "Continue", visible = false})
      hidesummaryButton = Gtk.Button({label = "Hide", margin_top = 75})
 
      summaryButton:set_visible(false)
      hidesummaryButton:set_visible(false)
      
      function summaryButton:on_clicked()
         -- Imports some modules
         local clear = require("lua.clear_grid")
         local show  = require("lua.summary.show")

         -- clears the grid
         clear.grid(grid)
         clear.grid(grid2)
         
         -- shows the summary
         show.summary(question,grid,theme)

         grid:set_visible(true)
         grid2:set_visible(true)
         labelEnd:set_visible(false)
         labelEndCorrect:set_visible(false)
         labelEndIncorrect:set_visible(false)
         resultButton:set_visible(false)
         summaryButton:set_visible(false)
         hidesummaryButton:set_visible(true)
         
         
      end

      function hidesummaryButton:on_clicked()
          
          labelEnd:set_visible(true)
          labelEndCorrect:set_visible(true)
          labelEndIncorrect:set_visible(true)
          resultButton:set_visible(true)
          summaryButton:set_visible(true)
          hidesummaryButton:set_visible(false)

          -- Hides the grids
          grid:set_visible(false)
          grid2:set_visible(false)

      end
      
      -- Create back button to go back to main
      backButton = Gtk.Button({label = "Go Back"})
      
      -- Makes exit button to exit
      local exitButton = Gtk.Button({label = "Exit", margin_top = 50})
      
      -- Defines the function of Resultbutton
      function resultButton:on_clicked()
          -- Import correct answers
          local question = require("lua.questionFunction") 
          -- Runs the function show_result
          show_result(question.correct, question.incorrect)
      end
      
      -- Imports window variable from mainWindow
      local mainWindowModule = require("lua.mainWindow")
      local mainWindow = mainWindowModule.app1
      
      -- Defines the function of Exitbutton
      function backButton:on_clicked()
          -- Resets the variables that keep tracks of current 
          -- question and correct answers
          correct_answers = 0
          incorrect_answers = 0
          currentQuestion = 1  -- Start from the first question if reached the end
          
          -- Make these variables empty to avoid stacking
          question.label_correct = {}
          question.label_incorrect = {}

          import.setQuestion(currentQuestion)
          
          win:destroy()
          mainWindow:activate()
      end

      function exitButton:on_clicked()

         local mainWindowModule = require("lua.mainWindow")

         local getSettingList = mainWindowModule.getSettingList
         local settingList = getSettingList()

         local comboWord = settingList.comboWord

         write.config_settings(replace,comboWord,combo)

          local configReplace = setconfigReplace(replace)
          -- Replace the cacheFile with the new values
          config = configReplace
          
          -- Runs function to replace
          writeTo_config(cacheFile,config)
            
          win:destroy()
          mainWindow:quit()
      end

      checkBox = Gtk.CheckButton({label = "Save", valign = Gtk.Align.Center , margin_top = 50})

      function checkBox:on_toggled()
         if checkBox.active then
            print("button activated")
         end
      end
  
      -- Appends these widgets to box
      box:append(grid)
      box:append(grid2)
      box:append(labelEnd)
      box:append(labelEndCorrect)
      box:append(labelEndIncorrect)
      box:append(resultButton)
      box:append(summaryButton)
      box:append(hidesummaryButton)
      box:append(restartButton)
      box:append(backButton)
      box:append(exitButton)
      box:append(checkBox)
  
      -- Appends box to the main window
      win.child = box
      
      -- Presents the main GTK window
      win:present()
  
  end -- End of app2:on_activate function
  
  return app2

end -- End of create_app2 function

-- Returns the functions
return {app2 = app2, create_app2 = create_app2 }

