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

-- Import function to write to cache file
local writeToConfigModule  = require("lua.settings")
local write_theme          = writeToConfigModule.write_theme
local write_setting        = writeToConfigModule.write_setting
local write                = writeToConfigModule.write

-- Gets current directory
local currentDir           = debug.getinfo(1, "S").source:sub(2)
currentDir                 = currentDir:match("(.*/)") or ""

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

    -- Model for the second combo box
    local modelWord = Gtk.ListStore.new({ GObject.Type.STRING })
  
    -- Function to list all word files inside lua_words
    local function getLuaFilesInDirectory(directory)
       local luaFiles = {}
 
       -- Loops through the directory
       for file in lfs.dir(directory) do
            local filePath = directory .. "/" .. file
            if lfs.attributes(filePath, "mode") == "file" and file:match("%.lua$") then
                table.insert(luaFiles, filePath)
            end
       end

       -- Sorts all the files
       table.sort(luaFiles)
    
       return luaFiles --Returns luaFiles variable to be used later
    end
    
    -- Calls the getluafilesdirectory function
    local directoryPath = luaWordsPath
    local luaFiles = getLuaFilesInDirectory(directoryPath)

      -- Add items to the wordfile combo box
    for _, luafiles in ipairs(luaFiles) do
        local luafilesFormatFirst = string.gsub(luafiles, "lua", "")
        local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
        local last = string.match(luafilesFormatSecond, "[^/]+$")
        local last = string.match(last, "([^.]+).")
        modelWord:append({ last })
    end
    
    -- Makes the combobox widget for wordlists
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
    

    local combo_set = combo.lang
    combo.set_value(config,customConfig,combo_set,fileExist,config.lang_set)
 
    -- set default label of labelWordList
    local wordActive = comboWord:get_active()
    local labelWordStringStart = luaFiles[wordActive + 1]
    local last = string.match(labelWordStringStart, "[^/]+$")
    local last = string.match(last, "([^.]+).")
    
    -- Updates the label of word_list
    label.word_list.label = "WordList "..wordActive.." selected (".. last ..")"
    label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
    
    -- Gets the active items in the combo boxes
    -- And stores it in settings just so we dont get errors
    -- Sometimes I got some errors when Launching the app
    -- If I didn't set these
    settings = {}
    settings.word       = comboWord:get_active()
    settings.lang       = combo.lang:get_active()
    settings.comboWord  = comboWord

    -- Creates combo word count box
    combo.word_count_create()

    -- adds the active word_count and stores it in settings
    settings.word_count = combo.word_count:get_active()

    -- Gets the length of the wordlist
    local activeWord           = comboWord:get_active()
    local choice               = modelWord[activeWord][1]
    local wordlist_first       = require(luaWordsModule .. "." .. choice)
    local wordlist_count_f     = #wordlist_first
    local wordlist_count_f_new = {}
    
    -- Gets the length of the wordlist file on startup
    for i = 1, wordlist_count_f do
            if i % 2 == 0 then -- Check if the index is even (every second number)
              table.insert(wordlist_count_f_new, i)
            end
    end
    
    -- Clears the model if it doesn't exist
    combo.word_model:clear()
    combo.word_count_items = {}
    for i = 1, #wordlist_count_f_new do
      combo.word_count_items[i] = wordlist_count_f_new[i]
      combo.word_model:append({ combo.word_count_items[i] })
    end
       
    local combo_set = combo.word_count
    combo.set_value(config,customConfig,combo_set,fileExist,config.word_count_set)

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
        write.config_main(replace,cacheFile,combo,comboWord)

    end
    
    
    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function comboWord:on_changed()
       local n = self:get_active()

        write.config_main(replace,cacheFile,combo,comboWord)
        
        -- Only get the list name
        newStr = luaFiles[n + 1]
        last = string.match(newStr, "[^/]+$")
        last = string.match(last, "([^.]+).")

        -- Updates label when you change option
        label.word_list.label = "WordList "..n.." selected (".. last ..")"
        label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
        
        -- Gets the length of the wordlist
        local activeWord   = comboWord:get_active()
        local choice       = modelWord[activeWord][1]
        wordlist = require(luaWordsModule .. "." .. choice)
        local wordlist_count = #wordlist
        local wordlist_count_new = {}
        
        -- Counts the length of the wordlist
        -- And appends the number to the combo word count widget
        if combo.word_model ~= nil then
          combo.word_model:clear()
          combo.word_count_items = {}
          if #wordlist >= 5 then
            for i = 1, wordlist_count do
              if i % 2 == 0 then -- Check if the index is even (every second number)
                table.insert(wordlist_count_new, i)
              end
            end
            for i = 1, #wordlist_count_new do
              combo.word_count_items[i] = wordlist_count_new[i]
              combo.word_model:append({ combo.word_count_items[i] })
            end
          else
           for i = 1, wordlist_count do
              combo.word_count_items[i] = i
              combo.word_model:append({ combo.word_count_items[i] })
            end
          end  

          if isFirstStart == true then         
              isFirstStart = false
              combo.word_count:set_active(config.word_count_set)
          else
              combo.word_count:set_active(3)
          end

        end
        
    end
   
    local combo_set = comboWord
    combo.set_value(config,customConfig,combo_set,fileExist,config.word_set)

    function combo.word_count:on_changed()
        local n = self:get_active()

        local success, result = pcall(function()
          -- Code that uses the variable
          label.word_count.label = "Selected "..combo.word_count_items[n + 1].." Words"
          label.word_count:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_count.label .. "</span>"  )
        end)

        write.config_main(replace,cacheFile,combo,comboWord)

    end
        
    --Combo --END
    
    -- Sets function to run when you click the exit button
    function button.exit:on_clicked()
       write.config_main(replace,cacheFile,combo,comboWord)
       
       win:destroy()
    end

    -- Create the function when you press on start
    function button.start:on_clicked()
        local activeWord      = comboWord:get_active()
        local activeWordCount = combo.word_count:get_active()

        local choice       = modelWord[activeWord][1]
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
               
      -- appends the back button
      widget.box_theme_main:append(notebook.theme)
      widget.box_theme_main:append(label.setting)
      widget.box_theme_main:append(notebook.setting)
      widget.box_theme_main:append(label.theme_apply)
      widget.box_theme_button:append(button.setting_submit)
      widget.box_theme_button:append(button.setting_back)
 

      -- Call some click actions
      button.click_action(widget, image2, label, theme, setting_default, theme_labels, write_theme, write_setting,setting_labels)
      -- Create Buttons --END    

    -- Adds the widgets to the Main Box
    widget.box_first:append(image)
    widget.box_first:append(label.welcome)
    widget.box_first:append(label.language)
    widget.box_first:append(combo.lang)
    widget.box_first:append(label.word_list)
    widget.box_first:append(comboWord)
    widget.box_first:append(label.word_count)
    widget.box_first:append(combo.word_count)
    widget.box_first:append(button.start)
    widget.box_first:append(label.sept)

    -- Add widgets to secondary box
    widget.box_second:append(button.setting)
    widget.box_second:append(button.exit)

    
    -- Initally hide the theme box
    widget.box_theme:set_visible(false)
    widget.box_setting:set_visible(false)
    widget.box_theme_alt:set_visible(false)
    widget.box_theme_main:set_visible(false)
    widget.box_theme_button:set_visible(false)
    widget.box_theme_label:set_visible(false)

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
