#!/usr/bin/env lua

-- Imports libaries we need
local lfs            = require("lfs")
local io             = require("io")
local os             = require("os")

-- Gets the current directory
local currentDir = debug.getinfo(1, "S").source:sub(2)
currentDir = currentDir:match("(.*/)") or ""

-- Append the current directory to the package path
package.path = currentDir .. "?.lua;" .. package.path

-- Imports init file
local import         = require("lua.init")

-- Sets home variable
local home           = os.getenv("HOME")

-- File exist function
local fileExist      = import.fileExists

-- Main window
local app1           = import.app1

-- Sets terminal variable

local p              = require("lua.terminal.processSwitch")

p.terminal           = false

-- Sets cachefile path
local cacheFile      = home .. "/.cache/azla.lua"

local terminal_init  = require("lua.terminal.init")

-- Create the cache file if it doesn't exist
if not fileExists(cacheFile) then
      local file = io.open(cacheFile, "w")
      
      file:write("config = {\n")
      file:write("}")
   
       -- Close the file
       file:close()

end

-- set luawords path
local luaWordsPath   = currentDir .. "lua/words/"
local luaWordsModule = "lua.words"

-- Process the switches 
p.processSwitches(luaWordsPath,luaWordsModule)

-- Activate app1
function app1:on_activate()
  self.active_window:present()
end

-- Runs the GUI app if you dont specify --term (-t)
if p.terminal == false then 
  
  -- Runs the app
  app1:run()

elseif p.terminal == true then

  -- runs terminal app
  terminal_init()

end -- End of if statement


