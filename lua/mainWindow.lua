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
local imagePath         = "/myrepos/azla/images/wp2106881.jpg"

-- Variable to store word arrays
local luaWordsPath      = "lua_words"

-- Sets variable that will determine language choice
local sharedVariable    = "azerbajani"

-- Creates the window where you input answers in azerbajani
-- Makes the main startup window
function app1:on_startup()
    local win = Gtk.ApplicationWindow({
        title = appTitle,
        application = self,
        class = "Azla",
        default_width = 600,
        default_height = 600,
        on_destroy = Gtk.main_quit,
        decorated = true,
        deletable = true,
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

    local wordlist = {}
    
      -- Changes the 'label' text when user change the combo box value
    function combo:on_changed()
        local n = self:get_active()
        labelLanguage.label = "Option "..n.." selected ("..items[n + 1]..")"
        if n == 0 then
           sharedVariable = "azerbajani"
        else
           sharedVariable = "english"
        end
    end
    
    
      -- Changes the 'label' text when user change the combo box value
    function comboWord:on_changed()
        local n = self:get_active()
        labelWordList.label = "WordList "..n.." selected ("..luaFiles[n + 1]..")"
    end


      -- Some labels used on the startup window
    local labelLanguage = Gtk.Label({ label = "Choose Language you want to write answers in:" })
    local labelWordList = Gtk.Label({ label = "Choose your wordlist",  height_request = 50, })
    local labelWelcome =  Gtk.Label({ 
                          label = "Welcome to AZLA",
                          width_request = 200,  -- Set the desired width
                          height_request = 100,
                          wrap = true })

    labelWelcome:set_markup("<span size='20000'>" .. labelWelcome.label .. "</span>"  )

    
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
        
        -- Starts the questions
        win:hide()
        local app2 = create_app2()
        app2:run()

      end

    -- Creates the image
    local image = create_image(home .. imagePath)

    -- Sets the size of the image
    image:set_size_request(200, 150)
    
    -- Adds the widgets to the Main window
    box:append(image)
    box:append(labelWelcome)
    box:append(labelLanguage)
    box:append(combo)
    box:append(labelWordList)
    box:append(comboWord)
    box:append(button)
    box:append(buttonExit)

    -- Appends box to the main window
    win.child = box
    

end

-- Creates the function to import the shared variable
function getSharedVariable()
    return sharedVariable
end

-- Export the necessary functions and variables
return {
    app1 = app1,
    getSharedVariable = getSharedVariable
}
