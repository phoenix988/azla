-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")
local theme             = require("lua.theme.default")

local button = {}
local home   = os.getenv("HOME")

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

function button.click_action(widget, image2, label, theme, setting_default,theme_labels,write_theme,write_setting,setting_labels)
  -- Creates the setting button click event
  function button.setting:on_clicked()
  
      widget.box_theme_main:set_visible(true)
      widget.box_theme:set_visible(true)
      widget.box_theme_alt:set_visible(true)
      widget.box_theme_button:set_visible(true)
      widget.box_setting:set_visible(true)
      widget.box_third:set_visible(true)
      widget.box_second:set_visible(true)
      widget.box_first:set_visible(false)
      widget.box_second:set_halign(Gtk.Align.CENTER)
      widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
      image2:set_visible(true)
  
      button.setting:set_visible(false)
  
  end

      -- Creates the back button function
  function button.setting_back:on_clicked()

          widget.box_theme:set_visible(false)
          widget.box_theme_alt:set_visible(false)
          widget.box_theme_main:set_visible(false)
          widget.box_theme_button:set_visible(false)
          widget.box_theme_label:set_visible(false)
          label.theme_apply:set_visible(false)
          widget.box_third:set_visible(false)
          widget.box_second:set_visible(true)
          widget.box_first:set_visible(true)
          button.setting:set_visible(true)
          widget.box_main:set_spacing(10)
          widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
          widget.box_second:set_halign(Gtk.Align.FILL)
          image2:set_visible(false)

  end


  function button.setting_submit:on_clicked()
         local apply         = {}
         local apply_setting = {}

         for key, value in pairs(theme) do
      
            local theme_choice = theme_labels[key].text:lower()

            apply[key] = theme_choice

         end

          write_theme(home .. "/.config/azla.lua", apply, theme)

         for key, value in pairs(setting_default) do
      
            local setting_choice =  setting_labels[key].text:lower()

            apply_setting[key] = setting_choice

         end

          write_setting(home .. "/.config/azla.lua", apply_setting, apply)
          label.theme_apply:set_visible(true)

  end




end

function button.result_create(show_result)

button.result = Gtk.Button({label = "Show Result"})

-- Defines the function of Resultbutton
function button.result:on_clicked()
    -- Import correct answers
    local question = require("lua.question.main") 
    -- Runs the function show_result
    show_result(question.correct, question.incorrect)
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
function button.summary_create(grid,grid2,wg)
 
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
         clear.grid(grid)
         clear.grid(grid2)
         
         -- shows the summary
         show.summary(question,grid,theme)

         grid:set_visible(true)
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
          grid:set_visible(false)
          grid2:set_visible(false)

      end
      

end

function button.back_exit_create(correct_answers,incorrect_answers,
                                 currentQuestion,question,import,win,mainWindow,
                                 replace,cacheFile,combo)
      backButton = Gtk.Button({label = "Go Back"})
      
       -- Makes exit button to exit
      exitButton = Gtk.Button({label = "Exit", margin_top = 50})
            
      
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
      
               local mainWindowModule = require("lua.main")
               local writeModule      = require("lua.settings")
               local write            = writeModule.write
      
               write.config_main(replace,cacheFile,combo)
      
               win:destroy()
               mainWindow:quit()

      
      end

    return { exit = exitButton, back = backButton }
      
end
return button
    

