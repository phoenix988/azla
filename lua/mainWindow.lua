-- Imports libaries we need
local lgi               = require("lgi")
local Gtk               = lgi.require("Gtk", "4.0")
local GObject           = lgi.require("GObject", "2.0")
local GdkPixbuf         = lgi.require('GdkPixbuf')
local lfs               = require("lfs")
local os                = require("os")

-- Other imports and global variables
-- Imports function to create images
local imageModule       = require("lua/createImage")
local create_image      = imageModule.create_image

-- Imports window 2
local appModule         = require("lua/questionMain")
local create_app2       = appModule.create_app2

-- Variables to make the application id
local appID1            = "io.github.Phoenix988.azla.main.lua"
local appTitle          = "Azla"
local app1              = Gtk.Application({ application_id = appID1 })

-- Gets users home directory
local home              = os.getenv("HOME")
local imagePath         = "/opt/azla/images/flag.jpg"

-- Imports Config function
local loadConfigModule  = require("lua/loadConfig")
local loadConfig        = loadConfigModule.load_config
local loadConfigCustom  = loadConfigModule.load_config_custom

-- Imports fileexist module
local fileExistModule = require("lua/fileExist")
local fileExist       = fileExistModule.fileExists

-- Variable to store word arrays
local luaWordsPath      = "lua_words"

-- Sets variable that will determine language choice
local exportLanguageChoice    = "azerbajani"

-- Sets window width and height empty variable
local width
local height 

-- load cachefile config
local cacheFile          = home .. "/.cache/azla.lua"
local configPath         = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
   config = ({})
end

-- Sets path of customConfig
local customConfig       = home .. "/.config/azla.lua"

-- Creates the config array if the custom file exist
if fileExist(customConfig) then
   local customPath = loadConfigCustom(customConfig) --Custom config exist
else
   local custom = ({}) --Custom config file doesn't exist
end

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()
    
    -- Gets the width and height to set on the window
    -- You can configure this in a config file
    if fileExist(customConfig) then
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
    
    -- Makes the main box widget to be used 
    local boxMain = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
    })
     
    -- Makes some other boxes
    local box = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
        width_request  = 200,
        height_request = 400,
        halign = Gtk.Align.FILL,
        valign = Gtk.Align.CENTER,
        hexpand = true,
        vexpand = true,
        margin_top    = 40,
        margin_bottom = 40,
        margin_start  = 40,
        margin_end    = 40
    })
 
    -- Makes secondary box
    local boxAlt = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 0,
        width_request  = 50,
        height_request = 50,
        halign = Gtk.Align.FILL,
        valign = Gtk.Align.BOTTOM,
        hexpand = true,
        vexpand = true,
        margin_start  = 40,
        margin_end    = 40
    })


    -- Some labels used on the startup window --START
    -- Language Label
    local labelLanguage = Gtk.Label({ label = "Choose Language you want to write answers in:" })

         -- Word list label
    local labelWordList = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })

    -- Welcome label for welcome message
    local labelWelcome =  Gtk.Label({ 
                          label = "Welcome to AZLA",
                          width_request = 200,  -- Set the desired width
                          height_request = 100,
                          wrap = true })
    local labelSept = Gtk.Label({label = ""})
 
    -- Sets size of the labels
    labelWelcome:set_markup("<span size='20000'>" .. labelWelcome.label .. "</span>"  )
    labelSept:set_markup("<span size='40000'>" .. labelSept.label .. "</span>"  )

    -- Label --END


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
        local luafilesFormatFirst = string.gsub(luafiles, "lua_words/", "")
        local luafilesFormatSecond = string.gsub(luafilesFormatFirst, ".lua", "")
        modelWord:append({ luafilesFormatSecond })
    end

    -- Makes the combobox widgets
    local combo = Gtk.ComboBox({
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
    
    -- Makes empty array to store my wordslist
    local wordlist = {}
    
    --If config file doesn't exist then it will set default value here
    if config == nil then
       combo:set_active(0)
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
          combo:set_active(defaultLang)
          
          if defaultLang == 0 then
              exportLanguageChoice = "azerbajani"
          else
              exportLanguageChoice = "english"
          end
       else
          if config.lang_set == nil then 
            combo:set_active(0)
          
          else
             
             local defaultLang = config.lang_set
             combo:set_active(defaultLang)
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

    labelWordList.label = "WordList "..wordActive.." selected (".. last ..")"

    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function combo:on_changed()
        -- Gets the current active combo number
        local n = self:get_active()
        local n_w = comboWord:get_active()
        
        -- Gets the dimensions of the screen
        width  = win:get_allocated_width()
        height = win:get_allocated_height()
        labelLanguage.label = "Option "..n.." selected ("..items[n + 1]..")"
        if n == 0 then
           -- Determines which languages to use
           -- Will use azerbajani
           exportLanguageChoice = "azerbajani"
        else
           -- Determines which languages to use
           -- Will use english
           exportLanguageChoice = "english"
        end

        configReplace =  {
           word_set = n_w,
           lang_set = n,
           default_width = width,
           default_height = height
           }

        -- Replace the cacheFile with the new values
        config = configReplace

        -- Write the updated config back to the file
        local file = io.open(cacheFile, "w")
        if file then
           file:write("config = {\n")
           for key, value in pairs(config) do
              file:write("   " .. key .. " = " .. tostring(value) .. ",\n")
           end
           file:write("}\n")
           file:close()
           print("Config file updated successfully.")
        else
           print("Failed to open config file.")
        end

        
    end
    
    
    -- Changes the 'label' text when user change the combo box value
    -- Also updates the cache file so it remembers the last choice when you exit the app
    function comboWord:on_changed()
        local n = self:get_active()
        local n_w = combo:get_active()

        -- Gets the screens dimensions
        width  = win:get_allocated_width()
        height = win:get_allocated_height()
        
        -- Only get the list name
        newStr = luaFiles[n + 1]
        last = string.match(newStr, "[^/]+$")
        last = string.match(last, "([^.]+).")

        -- Updates label when you change option
        labelWordList.label = "WordList "..n.." selected (".. last ..")"
        
       
        configReplace =  {
           word_set = n,
           lang_set = n_w,
           width_default = width,
           height_default = height
           }


        -- Replace the cacheFile with the new values
        config = configReplace

        -- Write the updated config back to the file
        local file = io.open(cacheFile, "w")
        if file then
           file:write("config = {\n")
           for key, value in pairs(config) do
              file:write("   " .. key .. " = " .. tostring(value) .. ",\n")
           end
           file:write("}\n")
           file:close()
           print("Config file updated successfully.")
        else
           print("Failed to open config file.")
        end



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

    -- Create Buttons --START    
    -- Create the start button
    local buttonStart = Gtk.Button({label = "Start", width_request = 100})
  
    -- Create the Exit button
    local buttonExit = Gtk.Button({label = "Exit", width_request = 30, })
    
    -- Sets function to run when you click the exit button
    function buttonExit:on_clicked()
        local n = comboWord:get_active()
        local n_w = combo:get_active()

        -- Gets the screens dimensions
        width  = win:get_allocated_width()
        height = win:get_allocated_height()

       configReplace =  {
           word_set = n,
           lang_set = n_w,
           default_width = width,
           default_height = height
           }

        -- Replace the cacheFile with the new values
        config = configReplace

        -- Write the updated config back to the file
        local file = io.open(cacheFile, "w")
        if file then
           file:write("config = {\n")
           for key, value in pairs(config) do
              file:write("   " .. key .. " = " .. tostring(value) .. ",\n")
           end
           file:write("}\n")
           file:close()
           print("Config file updated successfully.")
        else
           print("Failed to open config file.")
        end

        -- Destroys the window
       win:destroy()
    end

    -- Create the function when you press on start
    function buttonStart:on_clicked()
        local active = combo:get_active()
        local activeWord = comboWord:get_active()
        local activeWord = activeWord + 1
        local getwordList = (luaFiles[activeWord])
        local getwordList = string.gsub(getwordList, ".lua" , "")
        local wordlistModule = require(getwordList)
        
        local wordlist = wordlistModule.wordlist
        
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
    box:append(image)
    box:append(labelWelcome)
    box:append(labelLanguage)
    box:append(combo)
    box:append(labelWordList)
    box:append(comboWord)
    box:append(buttonStart)
    box:append(labelSept)
    
    -- Add widgets to secondary box
    boxAlt:append(buttonExit)

    -- Appends both boxes to the main one
    boxMain:append(box)
    boxMain:append(boxAlt)

    -- Appends box to the main window
    win.child = boxMain
end -- End of the app function


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

-- Export the necessary functions and variables
return {
    app1 = app1,
    getLanguageChoice = getLanguageChoice,
}
