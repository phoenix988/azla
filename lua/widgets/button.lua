-- Imports libaries we need
local lgi         = require("lgi")
local Gtk         = lgi.require("Gtk", "4.0")
local GObject     = lgi.require("GObject", "2.0")
local GdkPixbuf   = lgi.require('GdkPixbuf')
local lfs         = require("lfs")
local os          = require("os")
local theme       = require("lua.theme.default")
local array       = require("lua.widgets.setting")
local fileExists  = require("lua.fileExist").fileExists
local mkdir       = require("lua.terminal.mkdir").mkdir

-- Import Variables
local var         = require("lua.config.init")

-- Create empty table
local button      = {}

-- import some functions related to buttons
local button      = require("lua.widgets.button.functions")

local home        = os.getenv("HOME")
local confPath    = var.customConfig
local confDir     = var.confDir

-- Create the start button
button.start = Gtk.Button({label = "Start", width_request = 100})

-- Create the Exit button
button.exit = Gtk.Button({label = "Exit", width_request = 100, })
button.exit_alt = Gtk.Button({label = "Exit", width_request = 100, })

button.setting = Gtk.Button ({label = "Settings", margin_bottom = 20})
button.setting_back = Gtk.Button ({label = "Back", margin_top = 8})
button.setting_submit = Gtk.Button ({label = "Apply", margin_top = 8})

-- Makes result button to show your result
button.result = Gtk.Button({label = "Show Result", visible = true})

function button.result_create(result)

      button.result = Gtk.Button({label = "Show Result"})
      
      -- Defines the function of Resultbutton
      function button.result:on_clicked()
          -- Import correct answers
          local question = require("lua.question.main") 
          -- Runs the function show_result
          result(question.correct, question.incorrect)
      end

end

function button.restart_create(win,app2,currentQuestion,import)

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

          question.label_correct = {}
          question.label_incorrect = {}

          import.setQuestion(currentQuestion)
          
          -- Relaunch the app
          win:destroy()
          app2:activate()
      end
end

-- Create summary and hidden buttons
function button.summary_create(grid1,grid2,wg)
 
      -- Creates summary button and hide button
      summaryButton = Gtk.Button({label = "Summary"})
      hidesummaryButton = Gtk.Button({label = "Hide", margin_top = 75})

      -- Create continue button
      continueButton = Gtk.Button({label = "Continue", visible = false})
      
      -- Hides summary and hidesummary button initally
      summaryButton:set_visible(false)
      hidesummaryButton:set_visible(false)

      -- Create click action on summaryButton
      function summaryButton:on_clicked()
          -- Imports some modules
          local clear = require("lua.clear_grid")
          local show  = require("lua.summary.show")

          -- clears the grid
          clear.grid(grid1)
          clear.grid(grid2)
          
          -- shows the summary
          show.summary(question,grid1,theme)

          grid1:set_visible(true)
          grid2:set_visible(true)
          wg.labelEnd:set_visible(false)
          wg.labelEndCorrect:set_visible(false)
          wg.labelEndIncorrect:set_visible(false)
          button.result:set_visible(false)
          summaryButton:set_visible(false)
          hidesummaryButton:set_visible(true)
         
      end

      -- Create click action on hidesummaryButton
      function hidesummaryButton:on_clicked()
          
          wg.labelEnd:set_visible(true)
          wg.labelEndCorrect:set_visible(true)
          wg.labelEndIncorrect:set_visible(true)
          button.result:set_visible(true)
          summaryButton:set_visible(true)
          hidesummaryButton:set_visible(false)

          -- Hides the grids
          grid1:set_visible(false)
          grid2:set_visible(false)

      end

end

return button
    

