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
local cacheFile         = home .. "/.cache/azla.lua"

-- Import function to write to cache file
local writeToConfigModule   = require("lua.settings")
local write                 = writeToConfigModule.write

-- Import the show_result function from resultModule.lua
local resultModule   = require("lua.showResult")
local show_result    = resultModule.show_result

-- Import SwitchQuestion function
local import         = require("lua.switchQuestion")
local switchQuestion = import.switchQuestion

-- Import the question Module
local question       = require("lua.question.main")
local questionMain   = question.main

-- Import shuffle
local shuffle           = require("lua.shuffle")

-- Sets app attributes
local appID2            = "io.github.Phoenix988.azla.az.lua"
local appTitle          = "Azla Question"
local app2              = Gtk.Application({ application_id = appID2 })

-- Imports combo widgets
local wc                = require("lua.widgets.init")

-- import widgets 
local wc                   = require("lua.widgets.init")
local widget_list          = {}

for key, _  in pairs(wc) do
     table.insert(widget_list, key)
end

-- Loops through them
 for _, value in ipairs(widget_list) do
      _G[value] = wc[value]
 end

-- Creates empty table to make some widgets 
local w                 = {}

-- Counts correct answers
local correct_answers   = 0
local incorrect_answers = 0

-- Calculates current question
local currentQuestion   = 1

local function create_app2()
  -- Create the application object
  local app2 = Gtk.Application({
      application_id = appID2,
      flags = {"HANDLES_OPEN"}
  })

  -- Create the main window function
  function app2:on_activate()
      
      local mainWindowModule = require("lua.main")
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

      wc.grid.grid_create()
      wc.grid.grid_1 = grid.grid_1
      wc.grid.grid_2 = grid.grid_2

      widget.box_question_create()
 
      -- Creates image for the app
      local image = create_image(imagePath)
      image:set_size_request(200, 150)
       
      -- Appends the image on the top
      box:append(image)

      -- Gets chosen wordlist value
      local getWordList = mainWindowModule.getWordList
      local wordlist = getWordList()
  
      -- Calls the shuffle function
      shuffle(wordlist)
      
      -- Runs the question Function
      questionMain(wordlist,
                   w,
                   box,
                   correct_answers,
                   incorrect_answers,
                   currentQuestion)
      
      -- Create end labels
      label.end_create()
      
      -- Create restart button and function
      wc.button.restart_create(win,app2,currentQuestion,import)
      
      -- Create summary buttons
      wc.button.summary_create(wc.grid.grid_1,wc.grid.grid_2,wg)
      
      -- Makes result button to show your result
      wc.button.result_create(show_result)
     
      wc.button.back_exit_create(correct_answers,incorrect_answers,
                              currentQuestion,question,import,win,mainWindowModule.app1,
                              replace,cacheFile,combo)

      widget.checkbox_create()
      
      -- Appends these widgets to box
      box:append(wc.grid.grid_1)
      box:append(wc.grid.grid_2)
      box:append(wg.labelEnd)
      box:append(wg.labelEndCorrect)
      box:append(wg.labelEndIncorrect)
      box:append(wc.button.result)
      box:append(summaryButton)
      box:append(hidesummaryButton)
      box:append(restartButton)
      box:append(backButton)
      box:append(exitButton)
      box:append(widget.checkbox_1)
  
      -- Appends box to the main window
      win.child = box
      
      -- Presents the main GTK window
      win:present()
  
  end -- End of app2:on_activate function
  
  return app2

end -- End of create_app2 function

-- Returns the functions
return {app2 = app2, create_app2 = create_app2 }

