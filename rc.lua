#!/usr/bin/env lua

-- Imports libaries we need
local lfs            = require("lfs")
local io             = require("io")
local os             = require("os")

-- Gets the current directory
local currentDir = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentDir:match("(.*/)") or ""

-- Append the current directory to the package path
package.path = currentDir .. "?.lua;" .. package.path

-- Imports init file
local terminal_init  = require("lua.terminal.init")

-- Import some switches variables
local p              = require("lua.terminal.processSwitch")

-- Import Variables
local var            = require("lua.config.init")

-- Sets home variable
local home           = os.getenv("HOME")

-- File exist function
local fileExist      = require("lua.fileExist")

-- Sets terminal variable
p.terminal           = false

-- Sets cachefile path
local cacheDir       = var.cacheDir
local cacheFile      = var.cacheFile

local mkdir          = require("lua.terminal.mkdir").mkdir

-- Create the cache file if it doesn't exist

if not fileExists(cacheDir) then
      mkdir(cacheDir)
end

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

-- Runs the GUI app if you dont specify --term (-t)
if p.terminal == false then 

  local import         = require("lua.init")
  
  -- Main window
  local app1           = import.app1

  -- Activate app1
  function app1:on_activate()
    self.active_window:present()
  end
  
  -- Runs the app
  app1:run()

elseif p.terminal == true then

  -- runs terminal app
  terminal_init()

end -- End of if statement



