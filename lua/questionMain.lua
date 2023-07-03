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
local setting_default   = require("lua.theme.setting")
local setting_default   = setting_default.load()
local font              = theme.font.load()
local theme             = theme.load()
local replace           = {}

-- Import keybindings 
local lol               = require("lua.bindings.init").lolQuestion

-- Other imports and global variables
-- Imports function to create images
local imageModule       = require("lua.createImage")
local create_image      = imageModule.create_image

-- Import Variables
local var               = require("lua.config.init")

-- Import style
local style             = require("lua.widgets.setting")

-- Define home variable
local home              = os.getenv("HOME")

-- Define image path
local imagePath         = setting_default.image

-- Cache file path
local cacheFile         = var.cacheFile
local confFile          = var.customConfig

-- load config
local loadConfig        = require("lua.loadConfig").load_config_custom

-- Import the show_result function from resultModule.lua
local resultModule      = require("lua.showResult")
local show_result       = resultModule.show_result

-- Import SwitchQuestion function
local import            = require("lua.switchQuestion")
local switchQuestion    = import.switchQuestion

-- Import the question Module
local question          = require("lua.question.main")
local questionMain      = question.main

-- Import shuffle
local shuffle           = require("lua.shuffle")

-- Sets app attributes
local appID2            = "io.github.Phoenix988.azla.az.lua"
local appTitle          = "Azla Question"
local app2              = Gtk.Application({ application_id = appID2 })

-- import widgets 
local wc                = require("lua.widgets.init")
local widget_list       = {}
local window_alt        = {}

for key, _  in pairs(wc) do
     table.insert(widget_list, key)
end

-- Loops through them
 for _, value in ipairs(widget_list) do
      _G[value] = wc[value]
 end

-- Creates empty table to make some widgets 
local w                 = {}

-- Calculates current question
local currentQuestion   = 1

-- Function to create the app
local function create_app2()

  -- Create the application object
  local app2 = Gtk.Application({
      application_id = appID2,
      flags = {"HANDLES_OPEN"}
  })

  -- Create the main window function
  function app2:on_activate()
      
      -- Imports some modules from main
      local mainWindowModule = require("lua.main")
      local getWordList      = mainWindowModule.getWordList
      local getDim           = mainWindowModule.getWindowDim
      local window           = getDim()
      
      -- Load theme everytime you launch this app
      local theme            = require("lua.theme.default")
      local theme            = theme.load()
      
      -- Creates main window
      local win = Gtk.ApplicationWindow({
         title = appTitle,
         application = self,
         class = "Azla",
         default_width = window.width,
         default_height = window.height,
         on_destroy = Gtk.main_quit,
         decorated = true,
         deletable = true,
      })
      
      -- Checks window state of main window
      windowState         = window.main:is_fullscreen()
      window_alt.question = win 
      
      -- If main window is fullscreen then app2 launch in fullscreen
      -- Sets window to fullscreen
      if windowState then
         win:fullscreen()
      end
      
      -- Creates grid used for the summary of your answers
      wc.grid:create()
      wc.grid.grid_1 = grid.grid_1
      wc.grid.grid_2 = grid.grid_2
      
      -- Create summary label
      label.summary_create()
      
      -- Create end labels
      label.end_create()
      
      -- Create boxes for the window
      local box = widget.box_question_create(Gtk.Orientation.VERTICAL, Gtk.Align.CENTER)
      local boxMain = widget.box_question_create()
      local box2 = widget.box_question_create(Gtk.Orientation.VERTICAL, Gtk.Align.CENTER)
      local box3 = widget.box_question_create(Gtk.Orientation.HORIZONTAL, Gtk.Align.CENTER)
      local box4 = widget.box_question_create(Gtk.Orientation.VERTICAL, Gtk.Align.CENTER)
      
      -- Hide some widgets initally
      box3:set_visible(false)
      label.summary:set_visible(false)

      -- Gets chosen wordlist value
      local wordlist = getWordList()
  
      -- Calls the shuffle function
      -- To randomize the order of wordlist
      shuffle(wordlist)
      
      -- Create grid
      local mainGrid = grid.main_create()
      local questionGrid = grid.main_create()
      
      
      -- Makes result button to show your result
      wc.button.result_create(show_result)
      
      local bt = {}

      -- Create restart button and function
      bt.again = wc.button.restart_create(win,app2,currentQuestion,import)
      
      -- Create summary buttons
      bt.sum = wc.button.summary_create(grid.grid_1,grid.grid_2,wg, box3)
      
      -- Create exit and back button
      bt.last = wc.button.back_exit_create(
                           currentQuestion,question,import,win,mainWindowModule.app1,
                           replace,cacheFile,combo)

      
     -- Calls the question Function
      questionMain(wordlist,
                   w,
                   questionGrid,
                   currentQuestion,
                   bt)

      -- Create checkbvox widget
      local checkbox = widget.checkbox_create(win)

      -- Creates image for the app and set size
      local image = create_image(imagePath)
      image:set_size_request(200, 150)
      image:set_margin_bottom(10)

      -- Create a scrolled window
      local scrolledWindow = Gtk.ScrolledWindow()

      -- Set the text view as the child of the scrolled window
      scrolledWindow:set_child(boxMain)

      -- Attach buttons to the main grid
      mainGrid:attach(wc.button.result,0, 2 ,1 , 1)
      mainGrid:attach(bt.sum.summary,0, 3 ,1 , 1)
      mainGrid:attach(bt.sum.hideSummary,0, 3 ,1 , 1)
      mainGrid:attach(bt.again.restart,0, 4 ,1 , 1)
      mainGrid:attach(bt.last.exit,0, 6 ,1 , 1)
      mainGrid:attach(bt.last.back,0, 5 ,1 , 1)

      style.set_theme(bt.last.back,{{size = font.fg_size / 1000, color = theme.label_question, border_color = theme.label_question}})
      style.set_theme(bt.last.exit)
      style.set_theme(bt.sum.summary)
      style.set_theme(bt.sum.hideSummary)
      style.set_theme(bt.again.restart)
      style.set_theme(wc.button.result)

      -- Create an accelerator group for keybindings
      local keyPress = Gtk.EventControllerKey()
     
      -- Connect the 'key-pressed' signal to the callback function
      keyPress.on_key_pressed = lol

      -- Add the event controller to the window
      win:add_controller(keyPress)
      
      -- Appends widget to box
      box:append(questionGrid)
      box:append(wg.labelEnd)
      box:append(wg.labelEndCorrect)
      box:append(wg.labelEndIncorrect)
      
      -- Appends widget to box2
      box2:append(mainGrid)
      box2:append(widget.checkbox_1)

      -- Appends these widgets to box3
      box3:append(wc.grid.grid_1)
      box3:append(wc.grid.grid_2)

      -- Appends the image on the top
      box4:append(image)
      box4:append(label.summary)

      -- Append widgets to the main Box so they are visible
      boxMain:append(box4)
      boxMain:append(box3)
      boxMain:append(box)
      boxMain:append(box2)
  
      -- Appends boxMain to the main window and adds scroll function
      win.child = scrolledWindow
      
      -- Presents the main GTK window
      win:present()
  
  end -- End of app2:on_activate function
  
  return app2

end -- End of create_app2 function

-- Function to return window property
local function getWinDim()
    return window_alt
end

-- Returns the functions
return {app2 = app2, create_app2 = create_app2, getWinDim = getWinDim }

