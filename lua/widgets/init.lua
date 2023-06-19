-- export widget

-- Import modules
local list = require("lua.terminal.listFiles")

-- Gets currentDirectory
local currentDir = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentDir:match("(.*/)") or ""

-- Create empty table
local wc = {}

-- path to widgets modules
local widget_mod = "lua.widgets"

-- list all the files
local files = list.dir(currentDir)

-- Loops throught them and imports them
for _, luafiles in ipairs(files) do
    local last = list.modify(luafiles)

    -- Import unless the name is init which is this file so we
    -- dont want to import init.lua 
    if last ~= "init" then
    
       wc[last] = require(widget_mod .. "." .. last)
    
    end

end

---- export widgets to be used 
wc.widget = wc.box
wc.array  = wc.setting

return wc

