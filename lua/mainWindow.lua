-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")

-- Import theme
local theme             = require("lua.theme.default")

-- Other imports and global variables
-- Imports function to create images
local imageModule       = require("lua.createImage")
local create_image      = imageModule.create_image

-- Imports window 2
local appModule         = require("lua.questionMain")
local create_app2       = appModule.create_app2

-- Variables to make the application id
local appID1            = "io.github.Phoenix988.azla.main.lua"
local appTitle          = "Azla"
local app1              = Gtk.Application({ application_id = appID1 })

-- Gets users home directory
local home              = os.getenv("HOME")
local imagePath         = theme.main_image 

-- Imports Config function
local loadConfigModule  = require("lua.loadConfig")
local loadConfig        = loadConfigModule.load_config
local loadConfigCustom  = loadConfigModule.load_config_custom

-- Imports fileexist module
local fileExistModule   = require("lua.fileExist")
local fileExist         = fileExistModule.fileExists

-- Import function to write to cache file
local writeToConfigModule   = require("lua.settings")
local writeTo_config        = writeToConfigModule.writeTo_config
local configReplace         = writeToConfigModule.setconfigReplace

-- Gets current directory
local currentDir        = debug.getinfo(1, "S").source:sub(2)
currentDir              = currentDir:match("(.*/)") or ""

-- Variable to store word arrays
local luaWordsPath      = currentDir .. "words"
local luaWordsModule    = "lua.words"

-- Sets variable that will determine language choice
local exportLanguageChoice = "azerbajani"

-- Sets window width and height empty variable
local width
local height 

local wordlist

-- load cachefile config
local cacheFile          = home .. "/.cache/azla.lua"
local configPath         = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
   config = ({})
end

-- Sets path of customConfig
local customConfig = home .. "/.config/azla.lua"

-- Creates the config array if the custom file exist
if fileExist(customConfig) then
   local customPath = loadConfigCustom(customConfig) --Custom config exist
else
   local custom = ({}) --Custom config file doesn't exist
end

-- import widgets 
local widget = require("lua.widgets.box")
local button = require("lua.widgets.button")
local label  = require("lua.widgets.label")

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()

    -- Gets the width and height to set on the window
    -- You can configure this in a config file
    if fileExist(customConfig) then
       -- Prints error if you dont name the variable custom inside the setting file
       if custom == nil then
           print("Error in config")
           os.exit()
       end
       
       if custom.default_height == nil then
           config.default_height = 800
       else
           config.default_height = custom.default_height
       end

       if custom.default_width == nil then
           config.default_width = 800
       else 
           config.default_width = custom.default_width
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
    -- Where you make some choice

    -- Model for the combo box
    local model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Model for the second combo box
    local modelWord = Gtk.ListStore.new({ GObject.Type.STRING })
  
    -- Define language options for language combo box
    local items = {
      "Azerbaijan",
      "English"
    }

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
    
       return luaFiles --Returns luaFiles variable to be used later
    end
    
    -- Calls the getluafilesdirectory function
    local directoryPath = luaWordsPath
    local luaFiles = getLuaFilesInDirectory(directoryPath)

    -- Add the items to the language model
    for _, name in ipairs(items) do
        model:append({ name })
    end
  
    -- Add items to the wordfile combo box
    for _, luafiles in ipairs(luaFiles) do
        local luafilesFormatFirst = string.gsub(luafiles, "lua", "")
        local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
        local last = string.match(luafilesFormatSecond, "[^/]+$")
        local last = string.match(last, "([^.]+).")
        modelWord:append({ last })
    end

    -- Makes the combobox widgets
    local comboLang = Gtk.ComboBox({
        model = model,
        active = 0,
        cells = {
          {
            Gtk.CellRendererText(),
            { text = 1 },
            align = Gtk.Align.START
          }
        }
    })
    
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
    
    --If config file doesn't exist then it will set default value here
    if config == nil then
       comboLang:set_active(0)
    else
       -- Use custom config if it exist
       -- Otherwise it use defaults
       -- Can probably make this better, right now it's just 
       -- a bunch of nested if statements
       if fileExist(customConfig) then
          if custom.lang_set == nil then
             if config.lang_set == nil then
                defaultLang = 0
             else
                defaultLang = config.lang_set
             end
          else
             defaultLang = custom.lang_set
          end
          comboLang:set_active(defaultLang)
          
          if defaultLang == 0 then
              exportLanguageChoice = "azerbajani"
          else
              exportLanguageChoice = "english"
          end
       else
          if config.lang_set == nil then 
            comboLang:set_active(0)
          
          else
             
             local defaultLang = config.lang_set
             comboLang:set_active(defaultLang)
             if defaultLang == 0 then
                 exportLanguageChoice = "azerbajani"
             else
                 exportLanguageChoice = "english"
             end
          end   
       end 
    end
 
    -- set default label of labelWordList
    local wordActive = comboWord:get_active()
    local labelWordStringStart = luaFiles[wordActive + 1]
    local last = string.match(labelWordStringStart, "[^/]+$")
    local last = string.match(last, "([^.]+).")

    label.word_list.label = "WordList "..wordActive.." selected (".. last ..")"
    label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
    
    settings = {}
    settings.word = comboWord:get_active()
    settings.lang = comboLang:get_active()

    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function comboLang:on_changed()
        -- Gets the current active combo number
        local n = self:get_active()
        local n_w = comboWord:get_active()
        
        -- Gets the dimensions of the screen
        width  = win:get_allocated_width()
        height = win:get_allocated_height()
        word   = n_w
        lang   = n
        
        label.language.label = "Option "..n.." selected ("..items[n + 1]..")"
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

        local configReplace = setconfigReplace(word,lang,width,height)

        -- Replace the cacheFile with the new values
        config = configReplace

        writeTo_config(cacheFile,config)
        
    end
    
    
    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function comboWord:on_changed()
        local n = self:get_active()
        local n_w = comboLang:get_active()

        settings.word = n
        settings.lang = n_w

        -- Gets the screens dimensions
        width  = win:get_allocated_width()
        height = win:get_allocated_height()
        
        -- Sets variables
        word = n
        lang = n_w
        
        -- Only get the list name
        newStr = luaFiles[n + 1]
        last = string.match(newStr, "[^/]+$")
        last = string.match(last, "([^.]+).")

        -- Updates label when you change option
        label.word_list.label = "WordList "..n.." selected (".. last ..")"
        label.word_list:set_markup("<span size='" .. theme.label_word_size .. "' foreground='" .. theme.label_word .. "'>" .. label.word_list.label .. "</span>"  )
        
        local configReplace = setconfigReplace(word,lang,width,height)
       
        -- Replace the cacheFile with the new values
        config = configReplace

        writeTo_config(cacheFile,config)
        
    end

    --If config file doesn't exist then it will set default value here
    if config == nil then
       comboWord:set_active(1)
    else
       if fileExist(customConfig) then
          if custom.word_set == nil then
             if config.word_set == nil then
               defaultWord = 0
             else
               defaultWord = config.word_set
             end

          else
             defaultWord = custom.word_set
          end
          comboWord:set_active(defaultWord)
       else 
          if config.word_set == nil then 
             comboWord:set_active(1)
          else  
             local defaultWord = config.word_set
             comboWord:set_active(defaultWord)
          end
       end
    end

    --Combo --END
    
    -- Sets function to run when you click the exit button
    function button.exit:on_clicked()
       local n = comboWord:get_active()
       local n_w = comboLang:get_active()

       -- Gets the screens dimensions
       width  = win:get_allocated_width()
       height = win:get_allocated_height()
       
       -- Sets some variables needed
       word = n
       lang = n_w

       local configReplace = setconfigReplace(word,lang,width,height)

       -- Replace the cacheFile with the new values
       config = configReplace

       writeTo_config(cacheFile,config)

       -- Destroys the window
       win:destroy()
    end

    -- Create the function when you press on start
    function button.start:on_clicked()
        local activeWord = comboWord:get_active()

        local choice = modelWord[activeWord][1]

        wordlist = require(luaWordsModule .. "." .. choice)
        
        width  = win:get_allocated_width()
        height = win:get_allocated_height()

        -- Starts the questions
        win:hide()
        local app2 = create_app2()
        app2:run()

      end
    -- Create Buttons --END    

    -- Creates the image
    local image = create_image(imagePath)

    -- Sets the size of the image
    image:set_size_request(200, 150)

    -- Adds the widgets to the Main Box
    widget.box_first:append(image)
    widget.box_first:append(label.welcome)
    widget.box_first:append(label.language)
    widget.box_first:append(comboLang)
    widget.box_first:append(label.word_list)
    widget.box_first:append(comboWord)
    widget.box_first:append(button.start)
    widget.box_first:append(label.sept)

    -- Add widgets to secondary box
    widget.box_second:append(button.exit)

    -- Appends both boxes to the main one
    widget.box_main:append(widget.box_first)
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

function getWordList()
    return wordlist
end

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
