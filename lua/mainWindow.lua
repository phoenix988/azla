-- Imports libaries we need
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "4.0")
local GObject = lgi.require("GObject", "2.0")
local GdkPixbuf = lgi.require('GdkPixbuf')
local lfs = require("lfs")

local imageModule = require("lua/createImage")
local create_image = imageModule.create_image

-- Imports window 2
local appModule = require("lua/questionAz")
local app2 = appModule.app2

-- Imports window 3
local app3Module = require("lua/questionEng")
local app3 = app3Module.app3

-- Variables to make the application id
local appID1 = "io.github.Phoenix988.azla.main.lua"
local appTitle = "Azla"
local app1 = Gtk.Application({ application_id = appID1 })


-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()
    local win = Gtk.ApplicationWindow({
        title = appTitle,
        application = self,
        class = "Azla",
        default_width = 600,
        default_height = 600,
        on_destroy = Gtk.main_quit
        })


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
    
       for file in lfs.dir(directory) do
            local filePath = directory .. "/" .. file
            if lfs.attributes(filePath, "mode") == "file" and file:match("%.lua$") then
                table.insert(luaFiles, filePath)
            end
       end
    
       return luaFiles
    end

    local directoryPath = "lua_words"
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

    -- Some labels used on the startup window
    local labelLanguage = Gtk.Label({ label = "Choose Language you want to write answers in:" })
    local labelWordList = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })
    local labelWelcome =  Gtk.Label({ 
                          label = "Welcome to AZLA",
                          width_request = 200,  -- Set the desired width
                          height_request = 100,
                          wrap = true })


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
    
      -- Changes the 'label' text when user change the combo box value
    function combo:on_changed()
        local n = self:get_active()
        labelLanguage.label = "Option "..n.." selected ("..items[n + 1]..")"
    end
    
    
      -- Changes the 'label' text when user change the combo box value
    function comboWord:on_changed()
        local n = self:get_active()
        labelWordList.label = "WordList "..n.." selected ("..luaFiles[n + 1]..")"
    end


    -- Makes the main box widget to be used 
    local box = Gtk.Box({
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER
    })

    -- Create the start button
    local button = Gtk.Button({label = "Start"})
  

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
    
        if active == 0 then
    
        win:hide() 
        app2:run()
        elseif active == 1 then
        win:hide() 
        app3:run()
        end
    end

    -- Creates the image
    local image = create_image("/home/karl/myrepos/azla/images/wp2106881.jpg")
    
    -- Adds the widgets to the Main window
    box:append(image)
    box:append(labelWelcome)
    box:append(labelLanguage)
    box:append(combo)
    box:append(labelWordList)
    box:append(comboWord)
    box:append(button)

    -- Appends box to the main window
    win.child = box

end


return {app1 = app1}
