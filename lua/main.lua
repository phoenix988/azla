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

-- Imports Config function
local loadConfigModule     = require("lua.loadConfig")
local loadConfig           = loadConfigModule.load_config
local loadConfigCustom     = loadConfigModule.load_config_custom

-- Imports fileexist module
local fileExistModule      = require("lua.fileExist")
local fileExist            = fileExistModule.fileExists

-- Import list function
local list                 = require("lua.terminal.listFiles")

-- Import function to write to cache file
local writeToConfigModule  = require("lua.settings")
local write                = writeToConfigModule.write

-- Import Variables
local var                  = require("lua.config.init")

-- Gets current directory
local currentDir           = debug.getinfo(1, "S").source:sub(2)
local currentDir           = currentDir:match("(.*/)") or ""

-- Variable to store word arrays
local luaWordsPath         = var.word_dir
local luaWordsModule       = "lua.words"

-- adds some variables to the wordItems table
local wordItems = {
    list = list,
    path = luaWordsPath
}

-- Sets default variable that will determine language choice
local exportLanguageChoice = "azerbajani"

-- Gets users home directory
local home                 = os.getenv("HOME")
local imagePath            = theme.main_image 

-- set cachefile config path
local cacheFile            = var.cacheFile

-- Sets path to customConfig
local customConfig         = var.customConfig

-- load cacheFile config
local configPath           = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
   config = ({})
end

-- Sets some empty arrays to be used later
-- Sets window table
local window               = {}

-- Variables tthat sets the application values
local appID1               = "io.github.Phoenix988.azla.main.lua"
local appTitle             = "Azla"
local app1                 = Gtk.Application({ application_id = appID1 })

-- Make a table of all widgets
for key, _  in pairs(wc) do
   table.insert(widget_list, key)
end

-- Loops through them and shortens the name
for _, value in ipairs(widget_list) do
   _G[value] = wc[value]
end

-- Creates the config array if the custom file exist
if fileExist(customConfig) then
   -- load custom config
   local customPath = loadConfigCustom(customConfig) --Custom config exist
else
   -- sets empty array if it doesnt exist
   local setting = ({}) --Custom config file doesn't exist
end

-- widgets to hide on startup
widget.hideBox = {
     {widget.box_theme       },
     {widget.box_setting     },
     {widget.box_theme_alt   },
     {widget.box_theme_main  },
     {widget.box_theme_button},
     {widget.box_theme_label },
}

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()

      
    write.window_size(customConfig,setting,config,fileExist)

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
     
     -- returns the window to be used later
     window.main       = win

    -- Combo box --START
    -- Here I am configuiring the combo box widgets for Azla 
    -- Where you make some choices in the app like choosing wordlist and language

    -- Model for the combo box
    combo:create_lang()
    
    -- Creates the instance of the combo class
    combo.set = combo:new(wordItems)
    
    -- Creates the wordlist box
    combo.set:create_word_list()
    
    -- Creates combo box for wordlist dir 
    --combo.set:create_word_dir()

    -- Creates combo word count box
    combo:create_word_count()
   
    -- Sets default label when you launch the app
    local set = combo:set_default_label()
    
    -- Updates the label of word_list
    label.word_list.label = "WordList "..set.wordActive.." selected (".. set.last_word_label ..")"
    label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
    
    -- Creates a table to pass through the combo class
    local input = { 
        activeWord = combo.word:get_active(),
        modelWord  = combo.word_list_model,
        module     = luaWordsModule,
        combo      = combo,
        config     = config,
        custom     = customConfig,
        fileExist  = fileExist,
    }

    -- Create all the combo words values on launch
    -- Creates the class instances
    combo.set    = combo:new(input)
    
    -- Count instance
    combo.count  = combo:new(input)
    
    -- Set count value
    combo.count:set_count_value()

    -- set value of lang combo box
    combo.set:set_value(combo.lang,config.lang_set)

    function combo.word_dir_change()
        local n   = combo.word_dir:get_active()
        local num = combo.word:get_active()

        local item = combo.word_dir_files[n + 1]

        combo.word_list_model:clear()
        local dir = list.dir(item, "lua")

        for _, luafiles in pairs(dir) do
            local add = list.modify(luafiles)
            combo.word_list_model:append({ add })
        end

        combo.word:set_active(0)

        -- Only get the list name
        local newStr = combo.word_dir_files[n + 1]
        local newStr = list.modify_dir(newStr)

        -- Updates label when you change option
        label.word_list.label = "WordList "..num.." selected (".. newStr ..")"
        label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )

        return newStr
    end
    
    -- Function that runs when you change wordlist directory in the box 
    --function combo.word_dir:on_changed()
    --    local combo_wordlist = combo.word_dir_change()
    --end

    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    -- Runs when the lang box changes
    function combo.lang:on_changed()
        -- Gets the current active combo number
        local n = self:get_active()
        
        window.width  = win:get_allocated_width()
        window.height = win:get_allocated_height()
        
        label.language.label = "Option "..n.." selected ("..combo.lang_items[n + 1]..")"
        label.language:set_markup("<span size='" .. theme.label_lang_size .. "' foreground='" .. theme.label_lang .. "'>" .. label.language.label .. "</span>"  )
        
        if n == 0 then
           -- Determines which languages to use
           -- Will use azerbajani
           exportLanguageChoice = "azerbajani"
        elseif n == 1 then
           -- Determines which languages to use
           -- Will use english
           exportLanguageChoice = "english"
        end
        
        -- Updates cachefile
        write.config_main(cacheFile,combo)

    end
    
    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    -- Runs when combo word list changes
    function combo.word:on_changed()

        window.width  = win:get_allocated_width()
        window.height = win:get_allocated_height()

        loadConfig(cacheFile)
        
        local n = self:get_active()

        write.config_main(cacheFile,combo)
        
        -- Only get the list name
        newStr = combo.word_files[n + 1]

        if newStr then
          last = list.modify(newStr)
        end

        -- Updates label when you change option
        if last then
           label.word_list.label = "WordList "..n.." selected (".. last ..")"
           label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
        end

        -- updates the combo boxes    
        local inputCount = { 
              activeWord = combo.word:get_active(),
              modelWord  = combo.word_list_model,
              module     = luaWordsModule,
              word_count_set = config.word_count_set
        }
        
        -- Sets the wordlist count when value changes
        combo.count = combo:new(inputCount)
        combo.count:set_count()
        
    end

    -- set value of word count combo box
    combo.set:set_value(combo.word_count,config.word_count_set)


    -- set value of word combo box
    combo.set:set_value(combo.word,config.word_set)
    
    -- Function that runs when combo word count changes
    function combo.word_count:on_changed()
        local n = self:get_active()

        window.width  = win:get_allocated_width()
        window.height = win:get_allocated_height()
        
        -- Removes any error message that could ocur when setting the count
        local success, result = pcall(function()
          -- Code that uses the variable
          label.word_count.label = "Selected "..combo.word_count_items[n + 1].." Words"
          label.word_count:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_count.label .. "</span>"  )
        end)

        write.config_main(cacheFile,combo)

    end

    -- Exports the default language option on startup
    local lang_value = combo.lang:get_active()

    if lang_value == 0 then
       exportLanguageChoice = "azerbajani"
    elseif lang_value == 1 then
       exportLanguageChoice = "english"
    end

    --Combo --END
    
    -- Returns som settings start
    -- Gets the active items in the combo boxes
    -- And stores it in settings just so we dont get errors
    -- Sometimes I got some errors when Launching the app
    -- If I didn't set these
    settings = {}
    settings.word       = combo.word:get_active()
    settings.lang       = combo.lang:get_active()
    settings.comboWord  = comboWord

    -- adds the active word_count and stores it in settings
    settings.word_count = combo.word_count:get_active()
    
    -- settings end
    
    -- Sets function to run when you click the exit button
    function button.exit:on_clicked()

       window.width  = win:get_allocated_width()
       window.height = win:get_allocated_height()

       write.config_main(cacheFile,combo)
       
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
        
        -- Gets the window dimeonsions to return them later
        window.width  = win:get_allocated_width()
        window.height = win:get_allocated_height()

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
    local list1 = array.theme_table(theme)

    -- Create default setting empty boxes
    local list2 = array.setting_table(theme)
             
    -- Create notebook widgets
    notebook:create()
    
    -- appends all the widgets to make them wisible
    widget.box_theme_main:append(notebook.theme)
    widget.box_theme_main:append(label.setting)
    widget.box_theme_main:append(notebook.setting)
    widget.box_theme_main:append(label.theme_apply)
    widget.box_theme_button:append(button.setting_submit)
    widget.box_theme_button:append(button.setting_back)
 
    widget.image =  image2
    widget.label =  label


    -- Call some click actions
    button.click_action(
    widget,
    image2,
    label,
    theme,
    setting_default,
    write
    )
    -- Create Buttons --END    

    -- Adds the widgets to the Main Box
    -- Add widgets to the main box
    -- first section is the widget and second one
    -- is which  box to append it to
    widget.append = {
         {image,            "main"},
         {label.welcome,    "main"},
         {label.language,   "main"},
         {combo.lang,       "main"},
         {label.word_list,  "main"},
       --{combo.word_dir,   "main"},
         {combo.word,       "main"},
         {label.word_count, "main"},
         {combo.word_count, "main"},
         {button.start,     "main"},
         {label.sept,       "main"},
         {button.setting,   "sec" },
         {button.exit,      "sec" },
    }
    
    
    -- appends all the widgets
    for i = 1, #widget.append do
        local check = widget.append[i][2]
        -- adds to the first box
        if check == "main" then
           widget.box_first:append(widget.append[i][1])
        -- adds to secondary box
        elseif check == check then
           widget.box_second:append(widget.append[i][1])
        end
    end
    
    -- Appends both boxes to the main one
    widget.box_main:append(widget.box_first)
    widget.box_main:append(widget.box_theme_main)
    widget.box_third:append(widget.box_theme_label)
    widget.box_main:append(widget.box_third)
    widget.box_main:append(widget.box_theme_button)
    widget.box_main:append(widget.box_second)
     
    -- Hides some widgets on startup
    -- stored in widget.hideBox
    local hideBox = widget.hideBox
    for i = 1, #hideBox do
        -- Initally hide the theme box
        local hide = hideBox[i][1]
        hide:set_visible(false)
    end

    -- Appends box to the main window
    win.child = widget.box_main
end -- End of the app function


-- Returns some variables
-- Creates the function to import the language variable
function getLanguageChoice()
    return exportLanguageChoice
end

-- Returns wordlist 
function getWordList()
    return wordlist
end

-- Returns the window height
function getWindowDim()
    return window
end

-- Returns some settings to be used
function getSettingList()
    return settings
end

-- Export the necessary functions and variables
return {
    app1              = app1,
    getWordList       = getWordList,
    getWindowDim      = getWindowDim,
    getSettingList    = getSettingList,
    getLanguageChoice = getLanguageChoice,
}
