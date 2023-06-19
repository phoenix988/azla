-- Imports libaries we need
local lgi                  = require("lgi")
local Gtk                  = lgi.require("Gtk", "4.0")
local GObject              = lgi.require("GObject", "2.0")
local GdkPixbuf            = lgi.require('GdkPixbuf')
local lfs                  = require("lfs")
local os                   = require("os")

-- Import theme
local theme                = require("lua.theme.default")
local setting_default      = require("lua.theme.setting")

-- Other imports and global variables
-- Imports function to create images
local imageModule          = require("lua.createImage")
local create_image         = imageModule.create_image

-- Imports window 2
local appModule            = require("lua.questionMain")
local create_app2          = appModule.create_app2

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

-- Imports Config function
local loadConfigModule     = require("lua.loadConfig")
local loadConfig           = loadConfigModule.load_config
local loadConfigCustom     = loadConfigModule.load_config_custom

-- Imports fileexist module
local fileExistModule      = require("lua.fileExist")
local fileExist            = fileExistModule.fileExists
local list                 = require("lua.terminal.listFiles")

-- Import function to write to cache file
local writeToConfigModule  = require("lua.settings")
local write_theme          = writeToConfigModule.write_theme
local write_setting        = writeToConfigModule.write_setting
local write                = writeToConfigModule.write

-- Gets current directory
local currentDir           = debug.getinfo(1, "S").source:sub(2)
local currentDir           = currentDir:match("(.*/)") or ""

-- Variable to store word arrays
local luaWordsPath         = currentDir .. "words"
local luaWordsModule       = "lua.words"

-- Sets default variable that will determine language choice
local exportLanguageChoice = "azerbajani"

-- Gets users home directory
local home                 = os.getenv("HOME")
local imagePath            = theme.main_image 

-- load cachefile config and set the path
local cacheFile            = home .. "/.cache/azla.lua"
local configPath           = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
   config = ({})
end

-- Sets path to customConfig
local customConfig         = home .. "/.config/azla.lua"

-- Sets window width and height variable
local width
local height 

-- Sets some empty arrays to be used later
local setting_labels         = {}
local setting_labels_setting = {}
local grid_widgets_setting   = {}
local theme_labels           = {}
local theme_labels_setting   = {}
local grid_widgets           = {}
local grid_widgets_2         = {}
local replace                = {}

-- Variables tthat sets the application values
local appID1               = "io.github.Phoenix988.azla.main.lua"
local appTitle             = "Azla"
local app1                 = Gtk.Application({ application_id = appID1 })

-- sets first start value
local isFirstStart = true

-- Creates the config array if the custom file exist
if fileExist(customConfig) then
   local customPath = loadConfigCustom(customConfig) --Custom config exist
else
   -- sets empty array 
   local setting = ({}) --Custom config file doesn't exist
end

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()

    -- Gets the width and height to set on the window
    -- You can configure this in a config file
    if fileExist(customConfig) then
       -- Prints error if you dont name the variable custom inside the setting file
       if setting == nil then
           print("Error in config")
           os.exit()
       end
       
       if setting.default_height == nil then
           config.default_height = 800
       else
           config.default_height = setting.default_height
       end

       if setting.default_width == nil then
           config.default_width = 800
       else 
           config.default_width = setting.default_width
       end

    else

       if config.default_width == nil then
           config.default_width = 600
       end   
       
       if config.default_height == nil then
           config.default_height = 800
       end

    end

    -- Creates the window
    local win = Gtk.ApplicationWindow({
        title = appTitle,
        application = self,
        class = "Azla",
        default_width =  config.default_width,
        default_height = config.default_height,
        on_destroy = Gtk.main_quit,
        decorated = true,
        deletable = true,
     })
    
    -- Combo box --START
    -- Here I am configuiring the combo box widgets for Azla 
    -- Where you make some choices in the app like choosing wordlist and language

    -- Model for the combo box
    combo.lang_create()

    combo.word_create(list,luaWordsPath)

    combo.set_value(config,customConfig,combo.lang,fileExist,config.lang_set)
    local set = combo.set_default_label(combo)
    
    -- Updates the label of word_list
    label.word_list.label = "WordList "..set.wordActive.." selected (".. set.last_word_label ..")"
    label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
    
    -- Gets the active items in the combo boxes
    -- And stores it in settings just so we dont get errors
    -- Sometimes I got some errors when Launching the app
    -- If I didn't set these
    settings = {}
    settings.word       = combo.word:get_active()
    settings.lang       = combo.lang:get_active()
    settings.comboWord  = comboWord

    -- Creates combo word count box
    combo.word_count_create()

    -- adds the active word_count and stores it in settings
    settings.word_count = combo.word_count:get_active()
    
    
    -- Makes some variable tables to export
    -- to the function combo.count_set_label
    local input = {}
    input.comboWord = combo.word:get_active() 
    input.modelWord = combo.word_list_model
    input.luaWordsModule = luaWordsModule
    
    -- runs the function
    local count_label = combo.count_set_label(input,combo)
    
    -- set value of word count combo box
    combo.set_value(config,customConfig,combo.word_count,fileExist,config.word_count_set)

    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function combo.lang:on_changed()
        -- Gets the current active combo number
        local n = self:get_active()
        
        label.language.label = "Option "..n.." selected ("..combo.lang_items[n + 1]..")"
        label.language:set_markup("<span size='" .. theme.label_lang_size .. "' foreground='" .. theme.label_lang .. "'>" .. label.language.label .. "</span>"  )
        
        if n == 0 then
           -- Determines which languages to use
           -- Will use azerbajani
           exportLanguageChoice = "azerbajani"
        else
           -- Determines which languages to use
           -- Will use english
           exportLanguageChoice = "english"
        end
        
        -- Updates cachefile
        write.config_main(replace,cacheFile,combo)

    end
    
    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function combo.word:on_changed()
       local n = self:get_active()

        write.config_main(replace,cacheFile,combo)
        
        -- Only get the list name
        newStr = combo.word_files[n + 1]
        last = string.match(newStr, "[^/]+$")
        last = string.match(last, "([^.]+).")

        -- Updates label when you change option
        label.word_list.label = "WordList "..n.." selected (".. last ..")"
        label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )

        -- updates the combo boxes    
        local input = { 
              activeWord = combo.word:get_active(),
              modelWord  = combo.word_list_model,
              module     = luaWordsModule
        }
        
        combo.set = combo:new(input)
        combo.set:set_label_count()
        
    end
   
    combo.set_value(config,customConfig,combo.word,fileExist,config.word_set)

    function combo.word_count:on_changed()
        local n = self:get_active()
        
        -- Removes any error message that could ocur when setting the count
        local success, result = pcall(function()
          -- Code that uses the variable
          label.word_count.label = "Selected "..combo.word_count_items[n + 1].." Words"
          label.word_count:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_count.label .. "</span>"  )
        end)

        write.config_main(replace,cacheFile,combo)

    end
        
    --Combo --END
    
    -- Sets function to run when you click the exit button
    function button.exit:on_clicked()
       write.config_main(replace,cacheFile,combo)
       
       win:destroy()
    end

    -- Create the function when you press on start
    function button.start:on_clicked()
        local activeWord      = combo.word:get_active()
        local activeWordCount = combo.word_count:get_active()

        local choice       = combo.word_list_model[activeWord][1]
        local choice_count = combo.word_model[activeWordCount][1]

        wordlist = require(luaWordsModule .. "." .. choice)
        wordlist.count = choice_count
        
        width  = win:get_allocated_width()
        height = win:get_allocated_height()

        -- Starts the questions
        win:hide()
        local app2 = create_app2()
        app2:run()

      end

      -- Creates the images
      local image = create_image(imagePath)
      local image2 = create_image(imagePath)
      
       -- Hide Image 2
      image2:set_visible(false)

      -- Sets the size of the image
      image:set_size_request(200, 150)
      image2:set_size_request(200, 150)

      -- apend widgets to box theme  
      widget.box_theme_main:append(image2)
      widget.box_theme_main:append(label.theme)
      
      -- Create theme entry boxes
      array.theme_table(theme,grid_widgets,theme_labels,theme_labels_setting,grid_widgets_2)

      -- Create default setting empty boxes
      array.setting_table(theme,grid_widgets_setting,setting_labels,setting_labels_setting,setting_default)
               
      -- appends all the widgets to make them wisible
      widget.box_theme_main:append(notebook.theme)
      widget.box_theme_main:append(label.setting)
      widget.box_theme_main:append(notebook.setting)
      widget.box_theme_main:append(label.theme_apply)
      widget.box_theme_button:append(button.setting_submit)
      widget.box_theme_button:append(button.setting_back)
 

      -- Call some click actions
      button.click_action(
      widget,
      image2,
      label,
      theme,
      setting_default,
      theme_labels,
      write_theme,
      write_setting,
      setting_labels
      )
      -- Create Buttons --END    

    -- Adds the widgets to the Main Box
   
    -- Add widgets to the main box
    -- first section is the widget and second one
    -- is which  box to append it to
    local append = {
          {image,            "main"},
          {label.welcome,    "main"},
          {label.language,   "main"},
          {combo.lang,       "main"},
          {label.word_list,  "main"},
          {combo.word,       "main"},
          {label.word_count, "main"},
          {combo.word_count, "main"},
          {button.start,     "main"},
          {label.sept,       "main"},
          {button.setting,   "sec" },
          {button.exit,      "sec" },
    }
    
    -- appends all the widgets
    for i = 1, #append do
        local check = append[i][2]
        -- adds to the first box
        if check == "main" then
           widget.box_first:append(append[i][1])
        -- adds to secondary box
        elseif check == check then
           widget.box_second:append(append[i][1])
        end
    end
    
    -- Appends both boxes to the main one
    widget.box_main:append(widget.box_first)
    widget.box_main:append(widget.box_theme_main)
    widget.box_third:append(widget.box_theme_label)
    widget.box_third:append(widget.box_theme_alt)
    widget.box_third:append(widget.box_setting)
    widget.box_main:append(widget.box_third)
    widget.box_main:append(widget.box_theme)
    widget.box_main:append(widget.box_theme_button)
    widget.box_main:append(widget.box_second)

    -- Initally hide the theme box
    widget.box_theme:set_visible(false)
    widget.box_setting:set_visible(false)
    widget.box_theme_alt:set_visible(false)
    widget.box_theme_main:set_visible(false)
    widget.box_theme_button:set_visible(false)
    widget.box_theme_label:set_visible(false)

    -- Appends box to the main window
    win.child = widget.box_main
end -- End of the app function


-- Returns some variables
-- Creates the function to import the language variable
function getLanguageChoice()
    return exportLanguageChoice
end

-- Returns the window height
function getWindowHeight()
    return height
end

-- Returns the window width
function getWindowWidth()
    return width
end

-- Returns wordlist 
function getWordList()
    return wordlist
end

-- Returns some settings to be used
function getSettingList()
    return settings
end


-- Export the necessary functions and variables
return {
    app1 = app1,
    getLanguageChoice = getLanguageChoice,
    getWordList = getWordList,
    getSettingList = getSettingList,
}
