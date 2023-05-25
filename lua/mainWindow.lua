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

local fileExistModule = require("lua/fileExist")
local fileExist       = fileExistModule.fileExists

-- Variable to store word arrays
local luaWordsPath      = "lua_words"

-- Sets variable that will determine language choice
local exportLanguageChoice    = "azerbajani"
local width
local height 

local cacheFile          = home .. "/.cache/azla.lua"
local configPath         = loadConfig(cacheFile)

-- Creates empty array of config so we dont get errors
-- If the cache file doesn't exist
if config == nil then
   config = ({})
end

local customConfig       = home .. "/.config/azla.lua"

if fileExist(customConfig) then
   local customPath = loadConfigCustom(customConfig) --Custom config exist
else
   local custom = ({}) --Custom config file doesn't exist
end

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()

    if config.default_width == nil then
        config.default_width = 600
    end   
    
    if config.default_height == nil then
        config.default_height = 800
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

    local boxMain = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
    })
     
    -- Makes the main box widget to be used 
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


    -- Some labels used on the startup window
    local labelLanguage = Gtk.Label({ label = "Choose Language you want to write answers in:" })
    local labelWordList = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })
    local labelWelcome =  Gtk.Label({ 
                          label = "Welcome to AZLA",
                          width_request = 200,  -- Set the desired width
                          height_request = 100,
                          wrap = true })
    local labelSept = Gtk.Label({label = ""})
    -- Sets size of labels
    labelWelcome:set_markup("<span size='20000'>" .. labelWelcome.label .. "</span>"  )
    labelSept:set_markup("<span size='40000'>" .. labelSept.label .. "</span>"  )


    -- Combo box --START
    -- Model for the combo box
    local model = Gtk.ListStore.new({ GObject.Type.STRING })

    -- Model for the second combo box
    local modelWord = Gtk.ListStore.new({ GObject.Type.STRING })
  
    -- Define language options
    local items = {
      "Azerbaijan",
      "English"
    }

    -- Function to list all word files
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
    
    -- Gets the lua files in word directory
    local directoryPath = luaWordsPath
    local luaFiles = getLuaFilesInDirectory(directoryPath)

    -- Add the items to the model
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
    
    -- Makes the combobox widgets for wordlists
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
    
    -- Makes empty array ti store my wordslist
    local wordlist = {}
    
    --If config file doesn't exist then it will set default value here
    if config == nil then
       combo:set_active(0)
    else
       -- Use custom config if it exist
       -- Otherwise it use defaults
       if fileExist(customConfig) then
          local defaultLang = custom.lang_set
          combo:set_active(defaultLang)
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


    -- Changes the 'label' text when user change the combo box value
    function combo:on_changed()
        -- Gets the current active combo number
        local n = self:get_active()
        local n_w = comboWord:get_active()
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

        searchString = "lang_set" -- String to search for
        local newText     = "   lang_set = " .. n
        local newTextWord = "   word_set = " .. n_w
        local file = io.open(cacheFile, "r")
        if file then
            local lineCount = 0
            for line in file:lines() do
              lineCount = lineCount + 1
              if string.find(line, searchString) then
                  break
              end
            end

           local lines = {}
           for line in file:lines() do
               table.insert(lines, line)
           end
           
           file:close()
           lines[lineCount] = newText
           
           file = io.open(cacheFile, "w")
           if file then
               file:write("config = { \n")
               file:write(lines[lineCount] .. ",", "\n")
               file:write(newTextWord .. ",", "\n")
               file:write("}")
               file:close()
               print("File modified successfully.")
           else
               print("Failed to open the file for writing.")
           end
       
       else
           print("Failed to open the file for reading.")

        end
    end
    
    
      -- Changes the 'label' text when user change the combo box value
    function comboWord:on_changed()
        local n = self:get_active()
        local n_w = combo:get_active()
        labelWordList.label = "WordList "..n.." selected ("..luaFiles[n + 1]..")"
       
        
        searchString = "word_set" -- String to search for
        local newText     = "   lang_set = " .. n_w
        local newTextWord = "   word_set = " .. n
        local file = io.open(cacheFile, "r")
        if file then
            local lineCount = 0
            for line in file:lines() do
              lineCount = lineCount + 1
              if string.find(line, searchString) then
                  break
              end
            end

           local lines = {}
           for line in file:lines() do
               table.insert(lines, line)
           end
           
           file:close()
           lines[lineCount] = newText
           
           file = io.open(cacheFile, "w")
           if file then
               file:write("config = { \n")
               file:write(lines[lineCount] .. ",", "\n")
               file:write(newTextWord .. ",", "\n")
               file:write("}")
               file:close()
               print("File modified successfully.")
           else
               print("Failed to open the file for writing.")
           end
       
       else
           print("Failed to open the file for reading.")

        end

    end

    --If config file doesn't exist then it will set default value here
    if config == nil then
       comboWord:set_active(1)
    else
       if fileExist(customConfig) then
          local defaultWord = custom.word_set
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
    local button = Gtk.Button({label = "Start", width_request = 100})
  
    local buttonExit = Gtk.Button({label = "Exit", width_request = 30, })
    
    -- Sets function to exit the application
    function buttonExit:on_clicked()
       win:destroy()
    end

    -- Create the function when you press on start
    function button:on_clicked()
     -- stack:set_visible_child_name("second")
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
    box:append(button)
    box:append(labelSept)
    
    boxAlt:append(buttonExit)

    boxMain:append(box)
    boxMain:append(boxAlt)

    -- Appends box to the main window
    win.child = boxMain
end


-- Creates the function to import the shared variable
function getLanguageChoice()
    return exportLanguageChoice
end

function getWindowHeight()
    return height
end


function getWindowWidth()
    return width
end

-- Export the necessary functions and variables
return {
    app1 = app1,
    getLanguageChoice = getLanguageChoice,
}
