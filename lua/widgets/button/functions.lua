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

local button      = {}

local confPath    = var.customConfig
local confDir     = var.confDir

function button.back_exit_create(correct_answers ,incorrect_answers,
                                 currentQuestion,question,import,
                                 win,mainWin,
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
                mainWin:activate()
            end
      
            function exitButton:on_clicked()
      
               local mainWindowModule = require("lua.main")
               local writeModule      = require("lua.settings")
               local getDim = mainWindowModule.getWindowDim
               local window = getDim()
               local write            = writeModule.write

               window.width  = win:get_allocated_width()
               window.height = win:get_allocated_height()
      
               write.config_main(cacheFile,combo)
      
               win:destroy()
               mainWin:quit()
      
      end

    return { exit = exitButton, back = backButton }
      
end

function button.click_action(widget, image, label, theme, setting, write)
  -- Creates the setting button click event
  function button.setting:on_clicked()

      local hideBox = widget.hideBox

      for i = 1, #hideBox do
         -- Initally hide the theme box
         local hide = hideBox[i][1]
         hide:set_visible(true)
      end

  
      widget.box_second:set_visible(true)
      widget.box_first:set_visible(false)
      widget.box_second:set_halign(Gtk.Align.CENTER)
      widget.box_main:set_orientation(Gtk.Orientation.VERTICAL)
      image:set_visible(true)
  
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
          image:set_visible(false)

  end


  function button.setting_submit:on_clicked()
         local apply         = {}
         local apply_setting = {}

         if not fileExists(confDir) then
            mkdir(confDir)
         end

         for key, value in pairs(theme) do
      
            local theme_choice = array.theme_labels[key].text:lower()

            apply[key] = theme_choice

         end

         write.theme(confPath, apply, theme, setting)

         for key, value in pairs(setting) do
      
            local setting_choice =  array.setting_labels[key].text:lower()

            apply_setting[key] = setting_choice

         end

         write.setting(confPath, apply_setting, apply)

         label.theme_apply:set_visible(true)

  end


end


return button

